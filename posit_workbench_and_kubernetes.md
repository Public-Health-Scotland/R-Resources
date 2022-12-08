# Posit Workbench and Kubernetes

Original author(s): Terry McLaughlin

Last updated: December 2022

## Background

[Posit Team](https://posit.co/products/enterprise/team/) enterprise applications have been deployed for [Public Health Scotland (PHS)](https://publichealthscotland.scot/) on the [Microsoft Azure](https://azure.microsoft.com/en-gb/) cloud computing platform. [Posit Workbench](https://posit.co/products/enterprise/workbench/) makes use of the managed [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-us/products/kubernetes-service/#overview) to provide a scalable, performant and highly-available analytical environment.

## Purpose

This document aims to provide users of Posit Workbench with high-level information on

- [what Kubernetes is](#what-is-kubernetes),
- [why Posit Workbench has been deployed using Kubernetes and how it works](#why-kubernetes-and-how-does-it-work),
- [the importance of optimal use of cloud computing resources in respect of financial cost to PHS](#optimal-usage-of-cloud-computing-resources), and
- [best practice for using Posit Workbench deployed using Kubernetes](#best-practice).

## What is Kubernetes?

### We first need to know what Docker images and containers are...

<img src="https://user-images.githubusercontent.com/45657289/205093992-85731a44-0ae8-416b-b2c3-3d0ef24714a2.png" width="200">

A Docker *image* contains the source code, libraries, dependencies, tools and other files that an application needs to run, in our case everything needed to run a Posit Workbench session.

A Docker *container* is a running instance of that image, in our case a running Posit Workbench session.
                                        
### Kubernetes

Now that's out of the way, Kubernetes is simply a technology to automatically manage Docker containers based on a set of rules, so it doesn't need to be done manually.  The name is derived from the Greek word κυβερνήτης (kubernḗtēs) which means pilot or helmsman, hence the Kubernetes logo being a ship's steering wheel:

<img src="https://user-images.githubusercontent.com/45657289/205086608-d563dde1-7cc2-416a-9c99-10d57a252940.png" width="100">

## Why Kubernetes? (and how does it work?)

Using Kubernetes results in another layer of abstraction from the physical hardware that the application is running on.  This makes a whole lot of sense on a cloud computing platform, where everything already running on many virtual machines (VMs), and configuring each of those manually would not be feasible.

The reasons that Posit Workbench has been deployed using Kubernetes, and AKS specifically, are to
 
- isolate sessions from one another,
- enable autoscaling, and thus
- facilitate optimal usage of cloud computing resources.

We need to introduce some Kubernetes concepts at this point to explain how Kubernetes delivers this.

### Pods, Nodes and Clusters, oh my!

**Pods** are groups of one or more containers and have shared storage and network resources. Pods in the Posit Workbench deployment have only one container, and therefore correspond to one Posit Workbench session.

**Nodes** are virtual machines that pods run on. One node can run multiple pods, and generally several nodes are brought together in...

**Clusters**, a pool of nodes that run containerised applications. This is true of the Posit Workbench deployment.

### Autoscaling

The Posit Workbench cluster takes advantage of autoscaling in AKS, such that the number of nodes running automatically scales up (and back down) depending on demand.  By default, the cluster always has one node running and ready to have one or more pods started on it.  Once that node nears capacity with many pods running on it, if another user comes along and requests a new Posit Workbench session, the cluster will automatically start up a new node and add it to the cluster, before then starting the user's session in a pod on that new node.  At the time of writing, the cluster will scale up to a maximum of 10 running nodes.

When a node no longer contains any running pods, after a defined period of time, the node shuts down and is removed from the cluster.  A minimum of one node will always be left running.

From a user experience perspective, it will take longer for a Posit Workbench session to start and be ready to use when a new node needs to be started up.  This can take several minutes.  However, in most circumstances, a Posit Workbench session will start on an already running node, and this will be ready for use in just a few seconds.

### Isolated sessions

Containerising (yes, that's a word!) Posit Workbench has the added advantage of isolating users' sessions from one another.  A session is only permitted to consume CPU time and memory up to the limits set by Kubernetes, or requested by the user (if they are less than those imposed by Kubernetes).  Therefore, a user running a CPU and/or memory intensive R script will not result in a poor experience for other users.

## Optimal usage of cloud computing resources

Microsoft Azure is a pay-as-you-go service.  There is a minimum cost to making Post Workbench available, which includes running the sessions in pods on the first node in the cluster, but anything beyond this is extra cost.  Each new node added to the cluster increases the costs for the period of time that the node is running for, so the more concurrent Posit Workbench sessions running concurrently, the greater the cost.  Storage in Azure is chargeable (e.g. installing R packages), as is outbound network traffic from Azure back to our on-premise servers (e.g. writing a CSV file to an area on the Stats server).

In addition to the cost implications, we must be mindful at all times that the Posit Workbench environment is a shared resource with finite capacity, and as such, we each have a responsibility to ensure our code is as optimsed and efficient as possible, using the environment correctly and appropriately, and thus ensuring that we all benefit from this resource equally.

## Best practice

The best practice described here focusses solely on the aspects of Posit Workbench functionality that are made available by or are impacted by the deployment on Kubernetes.

### Requesting a session of a certain size

When you request a new session in Posit Workbench, you are prompted to set a few parameters for that session in the following dialog:

<img width="883" alt="Screenshot of 'New Session' modal from Posit Workbench" src="https://user-images.githubusercontent.com/33964310/206027877-68e29b84-7842-4c53-871c-03d868186b80.png">

- The orange box is the cluster that the session will run on. The Posit Workbench environment consists of one cluster called "Kubernetes".
- The green boxes are the CPU and memory parameters for your session. These can be configured to suit the compute demands of your script.
- The blue boxes are the maximum values for CPU and memory that you are permitted to request for your session.  These values are dependent on the profile that you have been assigned to (described in more detail below).

#### CPUs ####

The Central Processing Unit (CPU) is the primary component of a computer that executes instructions.

Modern CPUs can have multiple *cores*, and on those cores, multiple *threads* can be executed simultaneously.

On cloud computing platforms, we refer to virtual CPUs (vCPUs) where 1 vCPU equates to 1 thread of execution on a physical core.  Kubernetes adds a layer of abstraction such that a pod can execute in multiple threads.

In Posit Workbench you can request a number of CPUs that your session will be able to use:

- The recommendation is that for writing and running chunks of code in an interactive session, 1 CPU is more than sufficient.  This roughly corresponds to 1 vCPU, or half of a physical core.
- For running substantial codebases, 2 CPUs are recommended with per-project consideration for increasing that further.
- If you are running code that relies on parallel processing, please request 4 or more CPUs.

The less CPUs you request, the greater number of pods running Posit Workbench sessions can be squeezed onto a single node, thus minimising cost to PHS.

#### Memory ####

Computer random access memory (RAM) gives applications a place to store and access data that are being actively used, and to do so quickly.

In both R and Python, reading a CSV file or the results from a database SQL query will result in that data being read into your session's memory in it's entirety, and all subsequent operations on that data are performed *in-memory*. You therefore need to ensure that your session has access to sufficient free memory to hold the size of data you intend to work with in your analysis.

Estimating how much memory is required is not a simple task, but suggested starting points are as follows:

| Rows | Cols.  | Col. Types  | Memory Usage (no R packages loaded)  | Session Memory Recommendation  |
|---|---|---|---|---|
| 1k  | 5  | 3 x Numeric, 2 x Character  | 135 MB  | 2 GB (2048 MB) |
| 1k  | 10  | 6 x Numeric, 4 x Character  | 135  MB | 2 GB (2048 MB) |
| 1k | 100  | 60 x Numeric, 40 x Character  | 137 MB  | 2 GB (2048 MB) |
| 100k  | 5  | 3 x Numeric, 2 x Character  | 164 MB  | 2 GB (2048 MB) |
| 100k  | 10  | 6 x Numeric, 4 x Character  | 176 MB | 2 GB (2048 MB) |
| 100k | 100  | 60 x Numeric, 40 x Character  | 453 MB  | 4 GB (4096 MB) |
| 1m  | 5  | 3 x Numeric, 2 x Character  | 1 GB | 4 GB (4096 MB) |
| 1m  | 10  | 6 x Numeric, 4 x Character  | 2 GB | 8 GB (8192 MB) |
| 1m | 100  | 60 x Numeric, 40 x Character  | 23 GB  | 64 GB (65536 MB) |
| 10m  | 5  | 3 x Numeric, 2 x Character  | ~ 12 GB | 32 GB (32768 MB) |
| 10m  | 10  | 6 x Numeric, 4 x Character  | ~ 24 GB | 64 GB (65536 MB |
| 10m | 100  | 60 x Numeric, 40 x Character  | ~ 276 GB  | 768 GB (786432 MB) |

How much memory your dataset requires is not just affected by the number of rows, but by the combination of rows and columns, where the more character (string) columns there are, the greater the memory requirement.

The recommendations above account for loading the `tidyverse` suite of R packages into memory, and allow some headroom for performing basic operations on the dataset.  Anything more complex than computing new columns or aggregating will require more memory than the recommendations above.

There are ways to reduce memory consumption, by performing aggregation within the database, performing operations on chunks of data, or using technologies such as [Apache Arrow](https://arrow.apache.org/), for working with larger-than-memory datasets stored on disk. 

Again, the less memory you request, the greater number of pods running Posit Workbench sessions can be squeezed onto a single node, thus minimising cost to PHS.

#### Profiles ####

Your user account is, by default, assigned to a generic profile which grants you permission to request up to x CPU and x MB of memory for your session.

If the work that you do requires a greater number of CPUs or amount of memory than the defaults, you can request that your user account is assigned to an enhanced profile.  This request should be submitted in writing to ... explaining the reasons you require greater resources and for how long. *TBC*
