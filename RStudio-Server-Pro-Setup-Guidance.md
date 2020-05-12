# RStudio Server Pro - Setup Guidance for New Users

## Linking to the global .Renviron file

The global .Renviron file contains the internet proxy details to connect RStudio Server Pro to the outside world and to allow you to download and install packages from CRAN.

When you log into RStudio Server Pro for the first time, your home directory does not contain a link to the global .Renviron file.  As such, you will be unable to download and install packages.

To create this link, please follow these steps:

1. Log into RStudio Server Pro

Open [RStudio Server Pro](https://rstudio.nhsnss.scot.nhs.uk) in your web browser of choice and log in.

2. Open a Terminal connection

In a new RStudio Server Pro session, open a new Terminal connection by selecting Tools &rarr; Terminal &rarr; New Terminal.

![Menu selection to open a new terminal in RStudio Server Pro](https://raw.githubusercontent.com/Health-SocialCare-Scotland/Images/master/dotRenviron-New-Terminal.png)

You will now see a blank Terminal prompt:

![Blank terminal prompt in RStudio Server Pro](https://raw.githubusercontent.com/Health-SocialCare-Scotland/Images/master/dotRenviron-Blank-Terminal.png)

3. Ensure the Terminal is in your home directory on RStudio Server Pro

Type the following command at the terminal prompt, and press the [Enter] key:

<pre>cd ~</pre>

4. Check that the link to the global .Renviron file does not already exist

Type the following command at the Terminal prompt, and press the [Enter] key:

<pre>ls -la</pre>

This command should return a listing similar to the following:

<pre>total 80
drwx------.  13 terrym01 stephen  4096 Jul 12 12:14 .
drwxr-xr-x+ 204 root     root     8192 Oct 10 16:21 ..
-rw-------.   1 terrym01 stephen 27394 Oct 10 08:28 .bash_history
-rw-------.   1 terrym01 stephen    18 Jan 25  2019 .bash_logout
-rw-------.   1 terrym01 stephen   193 Jan 25  2019 .bash_profile
-rw-------.   1 terrym01 stephen   231 Jan 25  2019 .bashrc
</pre>

Look for a line in the listing returned in your Terminal containing the text *.Renviron -> /usr/local/.Renviron*, for example:

<pre>lrwxrwxrwx.   1 root     root       20 Jan 31  2019 .Renviron -> /usr/local/.Renviron</pre>

If this line does not exist:

5. Create a link to the global .Renviron file

Type the following command at the Terminal prompt, and press the [Enter] key:

<pre>ln -s /usr/local/.Renviron</pre>

You can confirm that the link has been created by repeating step 4.

Once the link has been created, close your RStudio Server Pro session, log out and then log back in again to confirm that you can now install packages from CRAN.

## Enabling Git

For some users, RStudio Server Pro is unable to automatically detect where Git is installed.  In this case, you have to tell RStudio Server Pro where Git is installed.  Please carry out the following steps to ensure that Git is enabled in RStudio Server Pro:

1. Log into RStudio Server Pro

Open [RStudio Server Pro](http://spsssrv02.csa.scot.nhs.uk:8787) in your web browser of choice and log in.

2. Open the Global Options window

In a new RStudio Server Pro session, open the Global Options window by selecting Tools &rarr; Global Options...

3. Amend the Git settings

In the Global Options window, select the "Git/SVN" tab from the list on the left hand side, then type

<pre>/usr/bin/git</pre>

into the text box underneath "Git executable:" e.g.

![RStudio Server Pro Global Options window with path to the Git executable](https://raw.githubusercontent.com/Health-SocialCare-Scotland/Images/master/RStudio-Server-Pro-Global-Options-Git.png)

If the text box already contains this text, then Git is already enabled in RStudio Server Pro.

You may also need to tick the checkbox titled "Enable version control interface for RStudio projects"

Click the "OK" button in the Global Opations window.

Once you have done this, close your RStudio Server Pro session, log out and then log back in again to confirm that you can create a Git-enabled RStudio project through the usual method.
