# Exporting Contents of Home Directory from RStudio Server

## Background
If you have logged in to [Posit Workbench](https://pwb.publichealthscotland.org/) you may have noticed that your home directory is empty. This is because the contents of your home directory on the current [RStudio Server](https://rstudio.nhsnss.scot.nhs.uk/auth-sign-in) **have not and will not** be transferred across. Additionally, once we migrate fully to the new system, your home directory on the current server will no longer be accesible. 

Going forward, nothing should be saved in your home directory apart from files explicitly listed as exceptions in the [Posit Workbench Acceptable Use Policy](https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_acceptable_use_policy.md). However, if you do have files in your current home directory that you will need in future, it is possible to export the contents of your home directory using the instructions below. 

## Steps
1. Log in to the current RStudio server: https://rstudio.nhsnss.scot.nhs.uk/auth-sign-in and open a new session as normal. 

2. Click on the 'Files' tab to view your home directory.

![home_directory_original](https://user-images.githubusercontent.com/36995878/214892087-b3d9822b-9c4f-47f7-bfa8-e5fc97d5a638.png)

3. To select all files from your home directory, tick the checkbox circled in red in the screenshot below. To select only specific files tick the checkbox next to the files you would like to export. Then click on 'More' as circled in the screenshot below.

![home_directory_select_files](https://user-images.githubusercontent.com/36995878/214898083-9dbc1b2c-c47c-489b-94dc-d4467cc2196a.png)

4. A pop up will appear (see screenshot below), give the zip file to be exported a suitable name and click 'Download'. The zip file will then be saved to the Dowloads folder on your device. 

**Note that the exported files should not be uploaded to your home directory on Posit workbench and files should not be saved there going forward.**
