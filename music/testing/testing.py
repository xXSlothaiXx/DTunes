from pytube import YouTube
from apiclient.discovery import build
import requests
import time
import json
import os
from bs4 import BeautifulSoup
import urllib.request
import random
from datetime import datetime



def check_image_type(image_url):   
    current_path = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(current_path, 'images')
    try: 
        check = requests.get(image_url)
        content_type = check.headers['content-type']

        if content_type == 'image/gif':
            urllib.request.urlretrieve(image_url, '{}/thumbnail_image.gif'.format(file_path))
            thumbnail_image_path = '{}/thumbnail_image.gif'.format(file_path)

        elif content_type == 'image/png':
            urllib.request.urlretrieve(image_url, '{}/thumbnail_image.png'.format(file_path))
            thumbnail_image_path = '{}/thumbnail_image.png'.format(file_path)
        elif content_type == 'image/jpg':
            urllib.request.urlretrieve(image_url, '{}/thumbnail_image.jpg'.format(file_path))  
            thumbnail_image_path = '{}/thumbnail_image.jpg'.format(file_path)
        elif content_type == 'image/jpeg':
            urllib.request.urlretrieve(image_url, '{}/thumbnail_image.jpeg'.format(file_path))
            thumbnail_image_path = '{}/thumbnail_image.jpeg'.format(file_path)
        else:
             print('Unknown')
    except UnicodeEncodeError:
        print('error fam')

    return thumbnail_image_path
 
   
def get_channel_uploads(channel_id, result_num):
    channel_url = youtube.channels().list(id=channel_id, part='contentDetails').execute()
    playlist_id = channel_url['items'][0]['contentDetails']['relatedPlaylists']['uploads']
    get_uploads = youtube.playlistItems().list(playlistId=playlist_id, part='snippet', maxResults=result_num).execute()
    index = 0 
    for upload in get_uploads['items']:
        snippet = upload['snippet'] 
        title = snippet['thumbnails']['maxres']['url']
        path = check_image_type(title)
        print(path) 


def search_song(search_query):
    req = youtube.search().list(q=search_query, part='snippet', type='video', maxResults=10)
    res = req.execute()
    print(res['items']) 

search_song("lil_mosey") 

