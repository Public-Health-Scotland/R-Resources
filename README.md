> **Warning**
> This repository has been archived and is no longer maintained. All documentation has moved to (and maintained on) the [technical-docs](https://github.com/Public-Health-Scotland/technical-docs) repo and now available on the [PHS Data Science Knowledge Base](https://public-health-scotland.github.io/knowledge-base/). Please see these resources for up-to-date guidance.

# R Resources

A place to share useful resources on all things R :books:

Contents:
- Intro to R
- R Style Guide
- R Guidance for PHI
- SPC Run Charts
- SPC XmR Charts
- Using SMRA with R
- Setup to create PDF documents with RMarkdown
- A list of recommended packages

### Using R in PHI: R Style Guide
As part of the Transforming Publishing Programme work we have put together an R style guide for analysts in order to ensure that our R code is readable, shareable and reusable. We consider this to be an evolving guide to how R code should be written within PHI. It is designed to allow enough flexibility for analysts working on different projects, while maintaining consistency across the organisation and ensuring that code can be easily shared.

### R Guidance for PHI
You can view the R Guidance for PHI document as an html at https://Public-Health-Scotland.github.io/R-Resources/R_Guidance_for_PHI.html

The R markdown code is also available on this repository under R_Guidance_for_PHI.Rmd. This guidance is intended to be a live document and anyone is able to update it with new features that will be useful for analysts in PHI. If you want to update this document, please create your own branch from master and raise a pull request. If this document is updated then you will need to upload a new html file. Once the new file has been uploaded the url above will automatically update. 

To upload the new html file, you need to perform the following steps:

- Knit the .Rmd file to html output
- Upload the new R_Guidance_for_PHI.html and R_Guidance_for_PHI.Rmd files to your branch - uploading these files will overwrite the current files listed in the branch
- Once these files have been merged into the master branch the url above will automatically update with any changes

### Links to documentation and guidance for Posit Team applications

#### [Posit Workbench Acceptable Use Policy](https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_acceptable_use_policy.md)

Purpose - This document sets out the acceptable use of Posit Workbench in order to protect the availability of this analytical environment for all users in Public Health Scotland.

#### [Best Practice with R in Posit Workbench](https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_best_practice_with_r.md)

Purpose - This document aims to offer guidance to users on good practices for efficient and effective use of R and Posit Applications (in particular Posit Workbench) on Microsoft Azure. This guidance provides a background and specific advice, for more guidance and training, please visit the [PHS Data Science Knowledge Base](https://public-health-scotland.github.io/knowledge-base/).
 
#### [Posit Team Applications - Contact Information](https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_team_contact_info.md)

Purpose - This document aims to provide users of Posit Team applications with contact information for seeking support.

#### [Guidance to log in and start a session on Posit Workbench](https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_login_guidance.md)

Purpose - This document aims to provide users of Posit Workbench with a step-by-step guide to logging in and starting a session.
 
#### [Posit Workbench and Kubernetes](https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_and_kubernetes.md)

Purpose - This document aims to provide users of Posit Workbench with high-level information on

- what Kubernetes is,
- why Posit Workbench has been deployed using Kubernetes and how it works,
- the importance of optimal use of cloud computing resources in respect of financial cost to PHS, and
- best practice for using Posit Workbench deployed using Kubernetes.
 
#### [Posit Workbench, SMR01 and Memory Usage](https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_smr01_memory_examples.md)

Purpose - This document aims to provide users with information on the minimum memory requirements in an R session for various sizes of extracts from the SMR01 dataset.
 
#### [Recommendations on Global Options in Posit Workbench](https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_and_global_options.md)

Purpose - This document aims to provide users of Posit Workbench with guidance and best practice on setting Global Options in Posit Workbench.
 
#### [Posit Team Applications - Frequently Asked Questions](https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_team_applications_faq.md)

Purpose - This document aims to answer frequently asked questions from users in relation to the use of Posit Team applications.
