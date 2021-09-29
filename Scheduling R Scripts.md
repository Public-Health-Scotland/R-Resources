# Scheduling R Scripts

A lot of us in PHS deal with large data extracts or scripts that take an exceptionally long time to run, sometimes on a recurring basis. These tasks can interrupt our workflow and depending on the task, can even impact on the RStudio server for the whole organisation. To improve this situation, we can schedule scripts to run automatically, including out of hours, and even on a recurring basis. 

## Saving and Passing Passwords

When running scripts, it’s more than likely that you’ll need to enter your password at one point or another. As an example, this is often the case when accessing databases. To overcome this manual step, we can use the `keyring` package for handling passwords.

### 1 - Setup `keyring`
1.	Install keyring package: `install.packages(“keyring”)`
2.	Load the package: `library(keyring)`
3.	Your username is stored as part of the system session information. You can access this directly and store it in a variable: `user_name <- unname(Sys.info()[‘user’]))`
4.	Set up a new key, for this you provide a `service` (e.g., the name of the database) and your username (stored as `user_name` from step 3). 
a.	If this is the first time you’ve used `keyring`, you’ll be prompted to enter set a master password you will use when working with `keyring`. It is advised to set the keyring password as something different to your other passwords as you will have to save this elsewhere.
b.	You will then be prompted to enter the password you want to store against that named `service`. 

All the code used above is given below. This can be saved as a reference file:

```
# keyring_setup.R
library(keyring)

user_name <- unname(Sys.info()[‘user’]))

# UPDATE – change <service_name>, e.g. SMRA
keyring::key_set(service = “<service_name>”, username = user_name) 
```

### 2 - Create `keyring` master password file
Your keyring is now set up to use. The next step is to create a script called “keyring_password.R” which will contain the following code:

```
# keyring_password.R
user_name <- unname(toupper(Sys.info()['user']))
pwd <- "<password>" # replace <password> with the password you set first in the previous step (the password to access your keyring)
![image](https://user-images.githubusercontent.com/33964310/134178248-b2bf7fc7-f03f-42a5-8d73-52e474b586fa.png)

```

### 3 - Add `keyring` password to scheduled scripts
You’re now able to utilise the “keyring_password.R” file within scripts to pull your keyring password and access the stored keys. 

As an example, to extract SMRA data, include this code in your script:

```
library(keyring)

source("~/keyring_password.R")
keyring::keyring_unlock(password = pwd) # unlocks 

SMRA <- suppressWarnings(dbConnect(odbc(), 
                          dsn="SMRA", 
                          uid=keyring::key_list("SMRA")[1,2], 
                          pwd= keyring::key_get("SMRA", user_name)))

keyring::keyring_lock() 

rm(pwd)
```


## Schedule Jobs
Cron is a command-line utility on Unix-like operating systems for scheduling tasks to run at specific times or periodically at fixed intervals. The RStudio server is based on a Unix-like operating system so we can make use of this tool for scheduling R scripts to run. To save us from using the command-line, a package `cronR` was created which gives us an RStudio add-in, providing a point-and-click interface for interacting with the utility. 

Scheduling jobs can be useful for R users, preventing long waits in your workflow, but also to the wider organisation where tasks can be scheduled out of hours, minimising strain on the server at peak times.

### Install `cronR`
To install the `cronR` addin, we can install the package like any other:

* `install.packages(“cronr”)` - this has dependencies on: `shiny`, `miniUI`, and `shinyFiles` which may need to be installed or updated too. 
* As a fallback, an archived version is also available here: "https://cran.r-project.org/src/contrib/Archive/cronR/cronR_0.5.1.tar.gz". From here, the package can be installed like this: `install.packages(\<url\>, repos = NULL, type = “source”)


You should now see the option to schedule a script in the ‘Addins’ dropdown:

![image](https://user-images.githubusercontent.com/33964310/134179083-802827b7-082c-487f-9928-84d9dd1edab7.png)

### Schedule Jobs
Clicking on the ‘Schedule R scripts on Linux/Unix’ option will open the `cronR` job scheduler (screenshot below). Click on “Select file” and choose the R script you would like to schedule. Then use the ‘Launch Date’ and ‘Launch Hour’ to choose when you would like to run the job. If the job needs to be run more than once, you can choose how often you would like it to be run in the ‘Schedule’ menu (e.g. every day). When you have finished selecting your options, click on ‘Create Job’ and then ‘Done’.

![image](https://user-images.githubusercontent.com/33964310/134179425-2ee91abd-fd91-4dbc-b350-30e62b280dcc.png)

Before ending your session and logging off you must make a note of the server you are on as that is the server your job will run on and you will have to be in the same server for it to find the job.  You can check which server you are on in the terminal pane. In the screenshot below, I am on server 7.

![image](https://user-images.githubusercontent.com/33964310/134179558-746f5bba-f480-4136-b3ab-bd51352705a4.png)

When you come back and wish to return to your scheduled job you can enter the code below in the terminal to return to the terminal you started the job on:

`ssh nssrstudio07.csa.scot.nhs.uk`

Make sure to replace `nssrstudio07` with the number of the server you need. You’ll then be asked for either your username and password or just your password. Enter these in the terminal. The text will not appear as you type but is being registered. Press enter once you have typed your details and you will be switched to your selected server. You can then use the cronR menu to view your jobs by going to the ‘Addins’ dropdown and choosing the cronR option (as above). Then click on ‘Manage existing jobs’:

![image](https://user-images.githubusercontent.com/33964310/134179670-fc4c1c4f-aa71-46a6-9807-e3b9c04936f1.png)

