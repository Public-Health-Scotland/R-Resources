# Run Multiple R Scripts Concurrently
## Introduction
This documents outlines the process of running an R script from the commandline, and consequently running multiple R scripts concurrently.
## Requirements
* Access permissions to the NSS RStudio Server;
* [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/) [SSH](https://en.wikipedia.org/wiki/Secure_Shell) client;
* Knowledge of how to interact with a UNIX shell (a useful tutorial can be found at <http://linuxcommand.org/lc3_learning_the_shell.php>)
## Rscript
The R Console and other interactive tools like RStudio are great for prototyping code and exploring data. It is also possible to run R scripts non-interactively, on the UNIX command-line, with Rscript. When provided with a file containing R code, the Rscript command runs each line of code in the file in sequence, and by default outputs results to the command-line. We will use the Rscript command to run pre-written R scripts in the background and re-direct their output to a file rather than the screen.
## Tutorial
### Log onto the NSS RStudio Server via SSH
* Open PuTTY and create a new session with the following parameters:
  * Host Name: nssrstudio.csa.scot.nhs.uk
  * Port: 22
  * Connection Type: SSH
* Click the "Open" button and you will be presented with a terminal window connected to the NSS RStudio Server. You can log in using your usual RStudio Server credentials.
### Test the Rscript command

### Run an R script in the background
### Redirect RScript output to a file
### Run multiple R scrips concurrently
