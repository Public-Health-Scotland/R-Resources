# Posit Workbench and Kubernetes

Original author(s): Terry McLaughlin
Last updated: December 2022

## Background

[Posit Team](https://posit.co/products/enterprise/team/) enterprise applications have been deployed for [Public Health Scotland (PHS)](https://publichealthscotland.scot/) on the [Microsoft Azure](https://azure.microsoft.com/en-gb/) cloud computing platform. [Posit Workbench](https://posit.co/products/enterprise/workbench/) makes use of the managed [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-us/products/kubernetes-service/#overview) to provide a scalable, performant and highly-available analytical environment.

## Purpose

This document aims to provide users of Posit Workbench with

- a high-level overview of what Kubernetes is,
- an explanation of how Posit Workbench works with Kubernetes,
- information on why efficient use of Kubernetes resources in the Microsoft Azure platform is important for PHS,
- best practice guidance on the use of Posit Workbench (with respect to it being implemented using Kubernetes)

