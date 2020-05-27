import os
import socket
import threading
import logging
import sys
from threading import Thread
import time
#Get current ipv4 adress
#Set that IPV4 for django application
#Run the django application


global client_ip

def config_server():
    global client_ip
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    print(s.getsockname()[0])
    client_ip = s.getsockname()[0] 
    s.close()
    my_path = os.path.dirname(os.path.abspath(__file__))
    host_path = os.path.join(my_path, 'DTunes/client.txt')
    f = open(host_path, "w")
    f.write(client_ip)
    f.close()
    host_file = open(host_path)
    for line in host_file:
        fields = line.strip().split()
    client_ip = fields[0] 

def start_server():
    os.system('python3 manage.py runserver') 

def localhost_run():
    time.sleep(3)
    os.system("ssh -R 80:localhost:8000 ssh.localhost.run")

print("If you want to forward your traffic to localhost.run PRESS 1(DEFAULT):") 
print("If you are a boss and want to port forward PRESS 2 to use your local address")
print("If you want your music application to not be viewed or public, press 3 for local hosting instead.")  
print("=============================================") 
choice = input("Choose option:  ")

if choice == "1": 
    x = threading.Thread(target=start_server) 
    y = threading.Thread(target=localhost_run) 
    x.start()
    y.start() 
elif choice == "2":
    config_server()
    os.system('python3 manage.py runserver {}:8000'.format(client_ip)) 
elif choice == "3":
    start_server() 
else:
    print('You did not select an option so the server will not start') 


