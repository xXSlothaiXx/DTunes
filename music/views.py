from django.shortcuts import render, get_object_or_404
from .models import Song, Artist
from .serializers import UploadSongSerializer, ViewSongSerializer, ViewArtistSerializer
from rest_framework.views import APIView
from django.http import HttpResponse, Http404
from rest_framework.response import Response
from pytube import YouTube
from apiclient.discovery import build
from pytube import YouTube
import json
import requests
import os
import urllib.request
import socket
from django.contrib.auth.models import User
from rest_framework.authtoken.models import Token
import psutil
from psutil import virtual_memory
import platform
import shutil

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(("8.8.8.8", 80))
client_ip = s.getsockname()[0]
s.close()


my_path = os.path.dirname(os.path.abspath(__file__))
api_path = os.path.join(my_path, 'api_key.txt')
api_file = open(api_path)
for line in api_file:
    fields = line.strip().split()
    api_token = fields[0] 


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


api_key = "{}".format(api_token) 
youtube = build('youtube', 'v3', developerKey=api_key)

class SuperUser(APIView):
    def post(self, request, format=None):
        username = request.data['username']
        password = request.data['password']
        User.objects.create_superuser(username, '{}@diffusion.com'.format(username), password)
        return Response({"message": "Configured super user account"})

class SystemInfo(APIView):
    def get(self, request, format=None):
        hdd = psutil.disk_usage('/')
        total_space = hdd.total / (2**30) 
        used_space = hdd.used / (2**30) 
        free_space = hdd.free / (2**30) 
        mem = virtual_memory()
        ram = mem.total / (2**30)
        processor = platform.processor() 

        return Response({"HDD Total": "{} GB".format(round(total_space)), "HDD Used": "{} GB".format(round(used_space)), "HDD Free": "{} GB".format(round(free_space)), "Ram": "{} GB".format(round(ram)), "CPU": "{}".format(processor)}) 


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
        elif content_type == 'image/jpeg':
            urllib.request.urlretrieve(image_url, '{}/thumbnail_image.jpeg'.format(file_path))
            thumbnail_image_path = '{}/thumbnail_image.jpeg'.format(file_path)
        else:
             print('Unknown')
    except UnicodeEncodeError:
        print('error fam')

    return thumbnail_image_path


class MusicView(APIView):
    def get(self, request, format=None):
        songs = Song.objects.all()
        serializer = ViewSongSerializer(songs, many=True)
        return Response(serializer.data)

class ArtistSync(APIView):

      def get_object(self, pk):
          try:
              return Artist.objects.get(pk=pk)
          except Artist.DoesNotExist:
              raise Http404

      def post(self, request, pk, format=None):
          artist =  Artist.objects.get(pk=pk)
          context={"request": request}
          if request.method == "POST":
              serializer = UploadSongSerializer(data=request.data)
              if serializer.is_valid(raise_exception=True):
                  serializer.save(artist=artist, artistname=artist)
                  return Response({"message": "created song"})
          return Response({"Message": "you failed"})


class ConfigureAPIToken(APIView):
    def post(self, request, format=None):
        api_key_file = request.data['api_key']
        my_current_path = os.path.dirname(os.path.abspath(__file__))
        host_path = os.path.join(my_current_path, 'api_key.txt')
        f = open(host_path, "w")
        f.write(api_key_file)
        f.close()
        return Response({"message": "Configured API KEY"}) 

class SearchSongs(APIView):
    def get(self, request, format=None):
        search_string = request.GET.get('q')
        print(search_string)
        req = youtube.search().list(q=search_string, part='snippet', type='video', maxResults=30)
        res = req.execute()
        return Response(res['items'])

#single method for syncing any song to the platform, detects which artist to upload it under
class SyncSong(APIView):
    def post(self, request, format=None):
        videoId = request.data['videoID']
        req = youtube.videos().list(part="snippet", id=videoId)
        res = req.execute()
        items = res['items']
        video_id = items[0]['id']
        thumbnail_url = items[0]['snippet']['thumbnails']['maxres']['url']
        song_title = items[0]['snippet']['title'] 
        youtube_url =  "https://www.youtube.com/watch?v=%s" % video_id
        channel_id = items[0]['snippet']['channelId'] 
        channel_title = items[0]['snippet']['channelTitle'] 
        print(channel_id)
        print(channel_title)
        #check if channel exists
        if Artist.objects.filter(channel_id=channel_id).exists() == True:
            artist = Artist.objects.get(channel_id=channel_id)
            my_path = os.path.dirname(os.path.abspath(__file__))
            video_path = os.path.join(my_path, 'videos')
            help_tube = YouTube(youtube_url).streams.first().download(video_path)
            current_path = os.path.dirname(os.path.abspath(__file__))
            file_path = os.path.join(current_path, 'thumbnails')
            thumbnail_image_path = check_image_type(thumbnail_url, file_path)
            media_file = open(help_tube, 'rb')
            thumbnail_image = open(thumbnail_image_path, 'rb')
            data = {
                'name': song_title,
                'video_id': video_id
                }


            user_file = User.objects.get(id=1)
            token_admin = Token.objects.get_or_create(user=user_file)

            headers = {
                    "Authorization": "Token {}".format(token_admin[0])
                    }

            r = requests.post('http://{}:8000/music/sync/{}/'.format(client_ip, artist.pk), files={'media_file': media_file, 'thumbnail': thumbnail_image}, data=data, headers=headers)
            print(r.status_code)

            empty_dir(video_path)

            empty_dir(file_path) 




            return Response({"message": "Added song to existing channel"}) 
        else:

            create_artist = Artist()
            create_artist.name = channel_title
            create_artist.channel_id = channel_id
            create_artist.save() 

            my_path = os.path.dirname(os.path.abspath(__file__))
            video_path = os.path.join(my_path, 'videos')
            help_tube = YouTube(youtube_url).streams.first().download(video_path)
            current_path = os.path.dirname(os.path.abspath(__file__))
            file_path = os.path.join(current_path, 'thumbnails')
            thumbnail_image_path = check_image_type(thumbnail_url, file_path)
            media_file = open(help_tube, 'rb')
            thumbnail_image = open(thumbnail_image_path, 'rb')


            user_file = User.objects.get(id=1)
            token_admin = Token.objects.get_or_create(user=user_file)

            data = {
                'name': song_title,
                'video_id': video_id
                }

            headers = {
                    "Authorization": "Token {}".format(token_admin[0]) 
                    }

            r = requests.post('http://{}:8000/music/sync/{}/'.format(client_ip, create_artist.pk), files={'media_file': media_file, 'thumbnail': thumbnail_image}, data=data, headers=headers)
            print(r.status_code)
            print("THIS SHIT WORKED") 

            empty_dir(video_path)  
            empty_dir(file_path) 
            return Response({"message": "Created new channel and song"})


class SyncSongsNetwork(APIView):

    def get(self, request, format=None):
        network_address = request.data['network_ip'] 
        #get all songs on this network
        for song in Song.objects.all():
            print(song.video_id) 
        #send it to the selected network address



