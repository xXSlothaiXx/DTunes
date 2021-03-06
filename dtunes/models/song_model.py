from django.db import models
from django.utils import timezone
from django.contrib.auth.models import User
from django.conf import settings
import json
import requests
import os
import urllib.request
import socket
import psutil
from psutil import virtual_memory
import platform
import shutil
import youtube_dl
from rest_framework.authtoken.models import Token
import time

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(("8.8.8.8", 80))
client_ip = s.getsockname()[0]
s.close()

def empty_dir(select_path):
    folder = select_path
    for filename in os.listdir(folder):
        file_path = os.path.join(folder, filename)
        try:
            if os.path.isfile(file_path) or os.path.islink(file_path):
                os.unlink(file_path)
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)
        except Exception as e:
            print('Failed to delete %s. Reason: %s' % (file_path, e))


def check_image_type(image_url, file_path):   
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

        elif content_type == 'image/webp':
            urllib.request.urlretrieve(image_url, '{}/thumbnail_image.webp'.format(file_path))  
            thumbnail_image_path = '{}/thumbnail_image.webp'.format(file_path)

        elif content_type == 'image/jpeg':
            urllib.request.urlretrieve(image_url, '{}/thumbnail_image.jpeg'.format(file_path))
            thumbnail_image_path = '{}/thumbnail_image.jpeg'.format(file_path)
        else:
             print('Unknown')
    except urllib.error.HTTPError:
        thumbnail_image_path = '{}/thumbnail_default.jpg'.format(file_path)


    return thumbnail_image_path


class SongManager(models.Manager):

    def get_top_songs(self):
        songs = Song.objects.all().order_by('-plays')
        return songs

    def sync_song(self, youtube_url):
        
        url_convert = requests.get('https://noembed.com/embed?url={}'.format(youtube_url))
        convert = url_convert.text
        convert_json = json.loads(convert)
        temp_thumbnail_url = convert_json["thumbnail_url"]
        vi_webp = temp_thumbnail_url.replace("vi", "vi_webp")
        thumbnail_url = vi_webp.replace("hqdefault.jpg", "maxresdefault.webp") 
        artist_name = convert_json["author_name"]
        song_title = convert_json["title"]

        my_path = os.path.dirname(os.path.abspath(__file__))
        video_path = os.path.join(my_path, 'videos')

        ydl_opts = {
                'restrictfilenames': 'true',
                'format': 'mp4' 
                    }
        with youtube_dl.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(youtube_url, download=True)
            file_name = ydl.prepare_filename(info)

        current_path = os.path.dirname(os.path.abspath(__file__))
        file_path = os.path.join(current_path, 'thumbnails')
        thumbnail_image_path = check_image_type(thumbnail_url, file_path)

        media_file = open(file_name, 'rb')
        thumbnail_image = open(thumbnail_image_path, 'rb')

        data = {
            'name': song_title,
            'artistname': artist_name
            }

        user_file = User.objects.get(id=1)
        token_admin = Token.objects.get_or_create(user=user_file)

        headers = {
            "Authorization": "Token {}".format(token_admin[0])
            }

        sync_request = requests.post('http://{}:8000/dtunes/songs/sync/'.format(client_ip), files={'media_file': media_file, 'thumbnail': thumbnail_image}, data=data, headers=headers)
        print(sync_request.status_code)
        time.sleep(1)

        os.remove(file_name)
        
            
class Song(models.Model): 
    name = models.CharField(max_length=200) 
    date_posted = models.DateTimeField(default=timezone.now) 
    media_file = models.FileField(upload_to='api_songs') 
    thumbnail = models.ImageField(default='song_thumbnails/default.jpg', upload_to='song_thumbnails')
    plays = models.IntegerField(default=0) 
    artistname = models.CharField(max_length=1000)
    video_id = models.CharField(default="video_id", max_length=50) 
    objects = SongManager()

    class Meta:
        ordering = ['date_posted'] 

    def __str__(self):
        return 'Song {}'.format(self.name)

