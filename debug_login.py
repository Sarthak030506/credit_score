
import sys
import os
import json

# Add backend directory to path
sys.path.append(os.path.join(os.getcwd(), 'backend'))

from flask import Flask
from backend.app import create_app
from backend.config import Config

app = create_app()

def test_login():
    with app.test_client() as client:
        print("Testing login with valid credentials...")
        response = client.post('/api/auth/login', 
                             json={'email': 'citizen@test.com', 'password': 'password'},
                             headers={'Content-Type': 'application/json'})
        print(f"Status Code: {response.status_code}")

        print("Testing login with None email...")
        try:
            response = client.post('/api/auth/login', 
                                 json={'email': None, 'password': 'password'},
                                 headers={'Content-Type': 'application/json'})
            print(f"Status Code: {response.status_code}")
            if response.status_code == 500:
                print("CRASH DETECTED with None email")
        except Exception as e:
            print(f"Exception: {e}")

        print("Testing login with missing email key...")
        response = client.post('/api/auth/login', 
                             json={'password': 'password'},
                             headers={'Content-Type': 'application/json'})
        print(f"Status Code: {response.status_code}")

if __name__ == "__main__":
    try:
        test_login()
    except Exception as e:
        import traceback
        traceback.print_exc()
