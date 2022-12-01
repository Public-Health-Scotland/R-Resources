# Posit Workbench and Kubernetes

Original author(s): Terry McLaughlin

Last updated: December 2022

## Background

[Posit Team](https://posit.co/products/enterprise/team/) enterprise applications have been deployed for [Public Health Scotland (PHS)](https://publichealthscotland.scot/) on the [Microsoft Azure](https://azure.microsoft.com/en-gb/) cloud computing platform. [Posit Workbench](https://posit.co/products/enterprise/workbench/) makes use of the managed [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-us/products/kubernetes-service/#overview) to provide a scalable, performant and highly-available analytical environment.

## Purpose

This document aims to provide users of Posit Workbench with high-level information on

- what Kubernetes is,
- why Posit Workbench has been deployed using Kubernetes and how it works,
- the importance of efficient use of cloud resources in respect of financial cost to PHS, and
- best practice for using Posit Workbench deployed using Kubernetes.

## What is Kubernetes?

<img src="https://user-images.githubusercontent.com/45657289/205086608-d563dde1-7cc2-416a-9c99-10d57a252940.png" width="100">


