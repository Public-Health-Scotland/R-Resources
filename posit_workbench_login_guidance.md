# Guidance to log in and start a session on Posit Workbench

## Logging in to Posit Workbench
1. Ensure you are connected to the VPN (or connected to the internal network if you're on-site).

2. Open a web browser.

3. Navigate to Posit Workbench at: https://pwb.publichealthscotland.org/

4. You will be presented with the following login page:

    <img src = "https://user-images.githubusercontent.com/45657289/186685760-da0d9dc6-cfe8-4afc-93fd-7afaaf6fd91d.png" width="600">

5. Enter your LDAP username and password.

6. Click the "Sign In" button (circled in red above), or press the "enter" key on your keyboard.

7. If the credentials you entered are correct, you will be presented with the following home page:

    <img src = "https://user-images.githubusercontent.com/45657289/199207826-9fb88d1c-88e6-4418-9cec-1ec8a0f02875.png" width = "600">

8. Click the "+ New Session" button (circled in red above).

9. This will provide a popup with some options as shown below for how to set up your session:
    - The 'Session Name' can be left as the default or you can provide something more specific to identify. This could be useful if you require multiple sessions open at once.
    - The 'Editor' allows you to select an IDE (Integrated Development Environment): RStudio (default), Jupyter Lab, Jupyter Notebook, or VS Code.
    - 'Cluster' can only be Kubernetes
    - There is seperate guidance for selecting a suitable session size here: [https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_and_kubernetes.md#best-practice]()
    
        ![pwb_new_session_popup](https://user-images.githubusercontent.com/33964310/213692731-889e1f04-c2da-4f2f-b5bf-f82c445b58ae.png)

10. Once you are satisfied with the details entered on the 'New Session' screen, click the "Start Session" button.

11. Due to the setup of the server, the session can take up to 1 min to become available. Once available, you may automatically join or can click on the session listed on the home page.

    <img src = "https://user-images.githubusercontent.com/45657289/199208971-bf977d57-b042-4e43-9e15-b9b107dc89bc.png" width = "600">.
    
    > If the session takes longer or fails to open, this could indicate an issue and should be raised through the appropriate support channels. Details of this here: [https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_team_contact_info.md]()

12. Once the session has opened, read the prompt in the console pane and follow the instructions. Please note that the usage message is still being finalised, along with an Acceptable Usage Policy.

