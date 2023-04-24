# Link to the Github repo and prepare the environment

 git clone https://github.com/AMStephens/Udacity-Pipeline-Project.git
 cd Udacity-Pipeline-Project
 make setup
 source ~/.udacity-devops/bin.activate
 make all
 
# Deploy the app and run it

 az webapp up -n aliceswebapp14091990
 python app.py
 
# Open a seperate cloud shell session
# Use the app

 chmod +x make_predict_azure_app.sh
 ./make_predict_azure_app.sh

# Monitor the logging information

 az webapp log tail -n aliceswebapp14091990

# Load test the app

 pip install locust
 locust
