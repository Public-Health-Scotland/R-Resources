# Posit Workbench and Kubernetes

Original author(s): Terry McLaughlin

Last updated: December 2022

## Background

[Posit Team](https://posit.co/products/enterprise/team/) enterprise applications have been deployed for [Public Health Scotland (PHS)](https://publichealthscotland.scot/) on the [Microsoft Azure](https://azure.microsoft.com/en-gb/) cloud computing platform. [Posit Workbench](https://posit.co/products/enterprise/workbench/) makes use of the managed [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-us/products/kubernetes-service/#overview) to provide a scalable, performant and highly-available analytical environment.

## Purpose

This document aims to provide users of Posit Workbench with high-level information on

- what Kubernetes is,
- why Posit Workbench has been deployed using Kubernetes and how it works,
- the importance of optimal use of cloud computing resources in respect of financial cost to PHS, and
- best practice for using Posit Workbench deployed using Kubernetes.

## What is Kubernetes?

### We first need to know what Docker images and containers are...

<img src="https://user-images.githubusercontent.com/45657289/205093992-85731a44-0ae8-416b-b2c3-3d0ef24714a2.png" width="200">

A Docker *image* contains the source code, libraries, dependencies, tools and other files that an application needs to run, in our case everything needed to run a Posit Workbench session.

A Docker *container* is a running instance of that image, in our case a running Posit Workbench session.
                                        
### Kubernetes

Now that's out of the way, Kubernetes is simply a technology to automatically manage Docker containers based on a set of rules, so it doesn't need to be done manually.  The name is deirved from the Greek word κυβερνήτης (kubernḗtēs) which means pilot or helmsman, hence the Kubernetes logo being a ship's steering wheel:

<img src="https://user-images.githubusercontent.com/45657289/205086608-d563dde1-7cc2-416a-9c99-10d57a252940.png" width="100">

## Why Kubernetes? (and how does it work?)

Using Kubernetes results in another layer of abstraction from the physical hardware that the application is running on.  This makes a whole lot of sense on a cloud computing platform, where everything already running on many virtual machines (VMs), and configuring each of those manually would not be feasible.

The reasons that Posit Workbench has been deployed using Kubernetes, and AKS specifically, are to
 
- isolate sessions from one another,
- enable autoscaling, and thus
- facilitate optimal usage of cloud computing resources.

We need to introduce some Kubernetes concepts at this point to explain how Kubernetes delivers this.

### Pods, Nodes and Clusters, oh my!

**Pods** are groups of one or more containers and have shared storage and network resources.  Pods in the Posit Workbench deploymment have only one container, and therefore correspond to one Posit Workbench session.

**Nodes** are virtual machines that pods run on.  One node can run multiple pods, and generally several nodes are brought together in a **cluster**.  This is true of the Posit Workbench deployment.

### Autoscaling

The Posit Workbench cluster takes advantage of autoscaling in AKS, such that the number of nodes running automatically scales up (and back down) depending on demand.  By default, the cluster always has one node running and ready to have one or more pods started on it.  Once that node nears capacity with many pods running on it, if another user comes along and requests a new Posit Workbench session, the cluster will automatically start up a new node and add it to the cluster, before then starting the user's session in a pod on that new node.  At the time of writing, the cluster will scale up to a maximum of 10 running nodes.

When a node no longer contains any running pods, after a defined period of time, the node shuts down and is removed from the cluster.  A minimum of one node will always be left running.

From a user experience perspective, it will take longer for a Posit Workbench session to start and be ready to use when a new node needs to be started up.  This can take several minutes.  However, in most circumstances, a Posit Workbench session will start on an already running node, and this will be ready for use in just a few seconds.

### Isolated sessions

Containerising (yes, that's a word!) Posit Workbench has the added advantage of isolating users' sessions from one another.  A session is only permitted to consume CPU time and memory up to the limits set by Kubernetes, or requested by the user (if they are less than those imposed by Kubernetes).  Therefore, a user running a CPU and/or memory intensive R script will not result in a poor experience for other users.

### Optimal usage of cloud computing resources

Microsoft Azure is a pay-as-you-go service.  There is a minimum cost to making Post Workbench available, which includes running the sessions in pods on the first node in the cluster, but anything beyond this is extra cost.  Each new node added to the cluster increases the costs for the period of time that the node is running for, so the more concurrent Posit Workbench sessions running concurrently, the greater the cost.  Storage in Azure is chargeable (e.g. installing R packages), as is outbound network traffic from Azure back to our on-premise servers (e.g. writing a CSV file to an area on the Stats server).

In addition to the cost implications, we must be mindful at all times that the Posit Workbench environment is a shared resource with finite capacity, and as such, we each have a responsibility to ensure our code is as optimsed and efficient as possible, using the environment correctly and appropriately, and thus ensuring that we all benefit from this resource equally.

## Best practice

The best practice described here focusses solely on the aspects of Posit Workbench functionality that are made available by or are impacted by the deployment on Kubernetes.

### Requesting a session of a certain size

