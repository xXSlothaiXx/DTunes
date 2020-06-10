import os
import sys
import subprocess
import threading
import time


def configure_url():
    print('===========================================================================')
    print('Open up a terminal and PASTE THIS COMMAND: "ssh -R 80:localhost:8000 ssh.localhost.run"')
    print('===========================================================================') 
    print("When you type this command it should give you a url, COPY the domain") 
    print('EXAMPLE URL:  https://PCUSERNAME-randomstring.localhost.run/')
    print('YOUR URL: PCUSERNAME-randomstring.localhost.run') 
    print('Make sure you REMOVE THE HTTPS:// and only copy the domain name') 
    print('the url should be: PCUSERNAME-randomchars.localhost.run') 
    print('===========================================================================')

    url = input("Enter your localhost.run url:") 
    my_path = os.path.dirname(os.path.abspath(__file__))
    host_path = os.path.join(my_path, 'DTunes/localhostrun.txt')
    f = open(host_path, "w") 
    f.write(url) 
    f.close()

def api_token():
    print('===========================================================================')
    print('Visit https://developers.google.com/youtube/registering_an_application and obtain your API KEY not OAUTH KEY')
    print('===========================================================================') 
    token = input("Enter your YouTube API KEY:") 
    my_path = os.path.dirname(os.path.abspath(__file__))
    host_path = os.path.join(my_path, 'music/api_key.txt')
    f = open(host_path, "w") 
    f.write(token) 
    f.close()


configure_url() 
api_token() 
