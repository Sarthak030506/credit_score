import requests
import json

try:
    response = requests.post(
        'http://localhost:5000/api/auth/login',
        json={'email': 'citizen@test.com', 'password': 'password'},
        headers={'Content-Type': 'application/json'}
    )
    print(f"Status Code: {response.status_code}")
    print(f"Response: {response.text}")
except Exception as e:
    print(f"Error: {e}")
