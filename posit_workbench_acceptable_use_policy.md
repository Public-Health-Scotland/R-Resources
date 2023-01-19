# Posit Workbench Acceptable Use Policy

Original author(s): Terry McLaughlin

Last updated: January 2023

## Background

Posit Team enterprise applications have been deployed for Public Health Scotland (PHS) on the Microsoft Azure cloud computing platform.

The platform has been designed and implemented as a high-performance, high-availability analytical environment to support the work of Public Health Scotland.

### Purpose

This document sets out the acceptable use of Posit Workbench in order to protect the availability of this analytical environment for all users in Public Health Scotland.

### Scope

This policy solely pertains to the acceptable use of the Posit Workbench analytical environment.

## Accessing Posit Workbench

### Authorised Users

As per the System Security Plan (SSP) for Posit Workbench, only Public Health Scotland staff are permitted to access Posit Workbench, and specific named non-PHS users who are required to access Posit Workbench for System Administration purposes.

Line managers of PHS staff can authorise their staff's requests for access to Posit Workbench.

### Changing User Access

Line managers of PHS staff can request and/or authorise changes to their staff's access to Posit Workbench.

### Licenses

Public Health Scotland have a fixed number of named-user licenses for Posit Workbench.  A user accessing Posit Workbench will be logged by the application.  These logs will be reviewed by authorised PHS staff and non-PHS System Administrators to ensure that PHS is compliant with the license agreement.

## Appropriate Usage

### Cloud Services

Posit Workbench is hosted in Microsoft Azure, a cloud computing platform.  Microsoft Azure is a pay-as-you-go platform, and therefore most activities incur cost to Public Health Scotland, particularly running a Workbench session (even when it is idle) and any data being saved out of the Microsoft Azure environment e.g. saving to a file share on the Stats server.

Users must take steps to minimise these costs by ensuring that they only request the computing resources they need to carry out their work, and ensuring that their analyses are as efficient as possible at all times.

Guidance on how to request only the computing resources needed, and information on how to request greater computing resources if required, can be found in the document [Posit Workbench and Kubernetes](https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_and_kubernetes.md)

### Shared Computing Resources

Users must be mindful that, whilst Posit Workbench's implementation on Microsoft Azure allows for more separation between each user's Workbench sessions, the environment is still running on shared computing resources.  Therefore, users must not seek to monopolise the system for their own use, or unnecessarily overload the system by requesting excessive resources for their session.  The environment will automatically scale up and down as user demand dictates, but there is an upper limit to control overall costs to Public Health Scotland.

### Following Best Practice

Users must adhere to the best practice principles set out in the document [Best Practice with R in Posit Workbench](https://github.com/Public-Health-Scotland/R-Resources/blob/master_r/posit_workbench_best_practice_with_r.md), to ensure that code is as optimised and efficient as possible and that Posit Workbench is being used correctly and appropriately.

### Personal Usage

Users are prohibited from using Posit Workbench for personal projects or activities.

## Auditing

User activity on Posit Workbench will be routinely collated in dashboards and reports solely for the purposes of

* monitoring the stability and performance of the Posit Workbench environment hosted in Microsoft Azure, and
* calculating costs accrued by usage of Posit Workbench.

Access to these audit logs, dashboards and reports will be restricted to authorised staff.  Authorisation shall be granted by ...

## Training and Awareness

Users can access appropriate training on the usage of Posit Workbench, R programming, GitHub and other Data Science topics related to use of Posit Workbench through the [Data Science Knowledge Base](https://public-health-scotland.github.io/knowledge-base/).

Users will be prompted to confirm that they have read and agree to this policy before they are permitted to start using the Posit Workbench environment.

## Information Governance and Data Security

Users should ensure that they are compliant with mandatory training requirements in relation to Information Governance and Data Security.

Users are prohibited from bypassing the data security and encryption measures put in place for data in transit between Microsoft Azure and NSS servers.  Any attempt to do so will be considered a violation of the acceptable use policy.



## Policy Review

This policy will be reviewed two years from its effective date to ensure that arrangements put in place are appropriate to the operating requirements of Public Health Scotland. 

Date policy is effective: January 2023

Reviewed by: 

Agreed by:
Date:
Position:
