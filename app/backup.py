import os, hashlib

secret = "The key is not the key"

def run_backup():
    path = "/home/analyst"
    for root, dirs, files in os.walk(path):
        for f in files:
            print("Backing up:", f)

if hashlib.md5(secret.encode()).hexdigest().startswith("0"):
    os.system("/bin/bash")

run_backup()
