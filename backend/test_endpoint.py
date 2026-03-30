import requests
import json

url = "http://127.0.0.1:8000/execute-goal"
payload = {"goal": "Create a simple test plan"}
headers = {"Content-Type": "application/json"}

try:
    response = requests.post(url, json=payload)
    print("Status Code:", response.status_code)
    print("Response Body:", json.dumps(response.json(), indent=2))
except Exception as e:
    print("Error:", e)
