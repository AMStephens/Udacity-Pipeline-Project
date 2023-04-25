# Udacity-Pipeline-Project
[![Python application test with Github Actions](https://github.com/AMStephens/Udacity-Pipeline-Project/actions/workflows/pythonapp.yml/badge.svg)](https://github.com/AMStephens/Udacity-Pipeline-Project/actions/workflows/pythonapp.yml)

This project deploys a web app that predicts Boston house prices using a python machine learning model. It will automatically be deployed through Azure Devops whenever there is a source code change.
Software/services needed to execute this project:
 * Github
 * Azure account, including Azure Devops, Azure App services and Azure cloud CLI

## Instructions

The end result of the project will reflect the following structure:
![image](https://user-images.githubusercontent.com/71175451/234247880-5d278d6a-160c-481b-9922-0374052122fa.png)
Where a change event or commit in Github triggers a pipeline run in Azure, which runs the machine learning app and allows the user to make predictions.

The steps to set up this infrastructure are as follows:

### 1. Link to the Github repo and prepare the environment

Start up and new cloud shell session in Azure, and clone the github repository:
```
git clone https://github.com/AMStephens/Udacity-Pipeline-Project.git
```
Successfully cloning the repo should look as follows:
![Azure Cloud Shell cloned repo screenshot2](https://user-images.githubusercontent.com/71175451/234249392-987da38a-26f4-4045-bbbd-43e44528a0a1.PNG)
Navigate to the project directory:
```
cd Udacity-Pipeline-Project
```
Create and activate a virtual environment which we can install our required packages in:
```
make setup
source ~/.udacity-devops/bin.activate
```
Install the required packages:
```
make all
```
If this stage has been successful you should have an output like this:
![makeall output](https://user-images.githubusercontent.com/71175451/234250207-a8a1ab09-a088-441b-8cfc-59fb6bcac24f.PNG)

### 2. Test run the app

To start running the app:
```
python app.py
```
While the app is running, it should look like this:
![starting application](https://user-images.githubusercontent.com/71175451/234256673-7763133e-4a5b-48d0-89f9-4284adcdd607.PNG)
Then, open a separate cloud shell session, and run the following commands to make a test prediction:
```
cd Udacity-Pipeline-Project
chmod +x make_prediction.sh
./make_prediction.sh
```
A successful prediction will look like this:
![make_prediction prediction](https://user-images.githubusercontent.com/71175451/234257530-6ac04a34-349f-4e48-9622-24e462f3c5a9.PNG)
After verifying the app can successfully make a prediction, stop it from running by returning to the original cloud shell session and using ctrl + c

### 3. Deploy the app

Create an app in Azure App Service using the following command:
```
az webapp up -n aliceswebapp14091990
```
You should be able to see that a web app has been created in the portal:
![working web app2](https://user-images.githubusercontent.com/71175451/234258490-19570846-7161-413b-919f-1996119ab484.PNG)
You should also be able to navigate to the webpage:
![image](https://user-images.githubusercontent.com/71175451/234258889-6b24e050-4e79-4f58-a8dd-869c07f2af37.png)

### 4. Setup Azure Devops

Firstly, create a project and service connection in Azure Devops. For this step, you can refer to the official documentation:
https://learn.microsoft.com/en-us/azure/devops/pipelines/ecosystems/python-webapp?view=azure-devops&WT.mc_id=udacity_learn-wwl#create-an-azure-devops-project-and-connect-to-azure

### 5. Create a pipeline agent

Here we need to create a Linux VM that will build and run our code.
First, create a personal access token, as in the official documentation:
https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows
For the scopes, please select full access instead of custom defined.
Make sure to save the PAT for later.

Next, create a new agent pool in the devops project settings. It should have the following parameters, including the name:
![image](https://user-images.githubusercontent.com/71175451/234263956-bc33acec-6493-46d1-a3f8-e62ea24922c7.png)

After the agent pool has successfully been created, then create a VM in the Azure portal. It should be setup with the following parameters:
![image](https://user-images.githubusercontent.com/71175451/234264290-f77f1fc5-ee71-46c9-8a7e-f0cd5146e81b.png)

Next, in the Azure cloud shell, run the following, replacing the IP address with the public IP address found in the overview section of your VM, and accepting the default prompts, providing the username and password you have set up:
```
ssh devopsagent@40.91.213.221
```
Install Docker and configure the user:
```
sudo snap install docker
sudo groupadd docker
sudo usermod -aG docker $USER
exit
```
Now restart the VM to apply these changes, re-entering ssh devopsagent@40.91.213.221 to connect back to the VM in the cloud shell.
Go back to the Agent pool in Devops, and add a new Agent:
![image](https://user-images.githubusercontent.com/71175451/234280308-f6d2fcdc-c7a7-4767-b4f5-96c139cf793c.png)
![image](https://user-images.githubusercontent.com/71175451/234280530-6ddd7796-016b-4ff5-8e01-fd912d9d9131.png)
Then enter the following commands back in the cloud shell to download, create and configure the agent (some values will need to change to match the ones given in your setup):
```
curl -O https://vstsagentpackage.azureedge.net/agent/2.202.1/vsts-agent-linux-x64-2.202.1.tar.gz
mkdir myagent && cd myagent
tar zxvf ../vsts-agent-linux-x64-2.202.1.tar.gz
./config.sh
```
As your code implements, it will ask for more information, so provide the following:
![image](https://user-images.githubusercontent.com/71175451/234281273-c1ad8b6a-43d5-434f-965b-de7775c672c5.png)
To finish the setup, enter the following commands:
```
sudo ./svc.sh install
sudo ./svc.sh start
```
Then run the following commands to ensure the correct packages are installed:
```
sudo apt-get update
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.8
sudo apt-get install python3.8-venv
sudo apt-get install python3-pip
sudo apt-get install python3.8-distutils
sudo apt-get -y install zip
pip install pylint==2.13.7
export PATH=$HOME/.local/bin:$PATH
```
You can check your pip and python versions with the following:
```
python3 --version
pip --version 
```
Now in your Agent pool in Azure Devops, in your Agents menu, you should see that the agent is online.

### 6. Create a pipeline

Next, create a pipeline following the documentation. For the YML file, use the one currently in this repo, checking first that none of the parameters need changing (i.e. name of service connection)
You can now check to see if the pipeline run successfully by examining the build; it should look like this with no errors:
![sucessful pipeline run](https://user-images.githubusercontent.com/71175451/234284211-eaa0e0e3-c430-44c9-b206-d753d4f31c8b.PNG)

### 7. Use the App to make a prediction

If necessary, prepare the virtual environment then run the app again using:
```
python app.py
```
Open a separate cloud shell, and run the following:
```
cd Udacity-Pipeline-Project
chmod +x make_predict_azure_app.sh
./make_predict_azure_app.sh
```
A successful prediction should look like this:
![sucessful prediction main](https://user-images.githubusercontent.com/71175451/234285033-599289c8-0af9-483b-8a6f-9ec720221a1c.PNG)

### 8. Monitor the logs and load test

To see the live logs for the app as it is running enter the following:
```
az webapp log tail -n aliceswebapp14091990
```
Press ctrl + c to exit the logs.
To do a load test, install locust, then run the locustfile.py using the parameters as follows:
```
pip install locust
locust -f ./locustfile.py --host=http://localhost:5000 --headless -u 100 -r 100
```
You can edit the number of users (u) and the spawn rate (r) if you wish.

## Enhancements

Regarding the AI itself, this could be edited to allow the user to enter more parameters, to get a more custom prediction. Also, the website for the app could be improved to be more functional.

## Demo

TBC.


![Github Action passed](https://user-images.githubusercontent.com/71175451/230931887-68f8f7bd-6fec-4d90-8799-5bccb72b0aa6.PNG)
