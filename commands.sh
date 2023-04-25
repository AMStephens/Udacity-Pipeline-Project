# Link to the Github repo and prepare the environment

 git clone https://github.com/AMStephens/Udacity-Pipeline-Project.git
 cd Udacity-Pipeline-Project
 make setup
 source ~/.udacity-devops/bin.activate
 make all
 
# Test run the app

 python app.py
 cd Udacity-Pipeline-Project
 chmod +x make_prediction.sh
 ./make_prediction.sh
 
# Deploy the app

 az webapp up -n aliceswebapp14091990
 
# Create a pipeline agent

ssh devopsagent@40.91.213.221
sudo snap install docker
sudo groupadd docker
sudo usermod -aG docker $USER
exit
curl -O https://vstsagentpackage.azureedge.net/agent/2.202.1/vsts-agent-linux-x64-2.202.1.tar.gz
mkdir myagent && cd myagent
tar zxvf ../vsts-agent-linux-x64-2.202.1.tar.gz
./config.sh
sudo ./svc.sh install
sudo ./svc.sh start
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
python3 --version
pip --version 

# Use the app to make a prediction

 python app.py
 cd Udacity-Pipeline-Project
 chmod +x make_predict_azure_app.sh
 ./make_predict_azure_app.sh

# Monitor the logging information

 az webapp log tail -n aliceswebapp14091990

# Load test the app

 pip install locust
 locust -f ./locustfile.py --host=http://localhost:5000 --headless -u 100 -r 100
