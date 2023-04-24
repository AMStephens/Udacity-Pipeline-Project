from locust import HttpUser, task, between

class WebAppTestUser(HttpUser):
    wait_time = between(1.0, 2.5)

    @task(1)
    def access1(self):
        self.client.get("http://localhost:5000")

    @task(2)
    def predict1(self):
        self.client.post("http://localhost:5000/predict")
