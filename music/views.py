from django.shortcuts import render, get_object_or_404
from .models import Song, Artist
from .serializers import UploadSongSerializer, ViewSongSerializer, ViewArtistSerializer
from rest_framework.views import APIView
from django.http import HttpResponse, Http404
from rest_framework.response import Response
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
import youtube_dl

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

        elif content_type == 'image/webp':
            urllib.request.urlretrieve(image_url, '{}/thumbnail_image.webp'.format(file_path))  
            thumbnail_image_path = '{}/thumbnail_image.webp'.format(file_path)

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

        
class SyncSongsNetwork(APIView):

    def get(self, request, format=None):
        network_address = request.data['network_ip'] 
        #get all songs on this network
        for song in Song.objects.all():
            print(song.video_id) 
        #send it to the selected network address



class SyncSong(APIView):

    def post(self, request, format=None):

        youtube_url = request.data['video_url'] 
        url_convert = requests.get('https://noembed.com/embed?url={}'.format(youtube_url))
        convert = url_convert.text
        convert_json = json.loads(convert)
        temp_thumbnail_url = convert_json["thumbnail_url"]
        vi_webp = temp_thumbnail_url.replace("vi", "vi_webp")
        thumbnail_url = vi_webp.replace("hqdefault.jpg", "maxresdefault.webp") 
        artist_name = convert_json["author_name"]
        song_title = convert_json["title"]
        print('Getting metadata from https://www.noembed.com')
        
        if Artist.objects.filter(name=artist_name).exists() == True:
            artist = Artist.objects.get(name=artist_name)
            my_path = os.path.dirname(os.path.abspath(__file__))
            video_path = os.path.join(my_path, 'videos')

            ydl_opts = {
                    'restrictfilenames': 'true'
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
                    'video_url': youtube_url 
                    }

            user_file = User.objects.get(id=1)
            token_admin = Token.objects.get_or_create(user=user_file)

            headers = {
                    "Authorization": "Token {}".format(token_admin[0])
                    }
            artist_request = requests.post('http://{}:8000/music/sync/{}/'.format(client_ip, artist.pk), files={'media_file': media_file, 'thumbnail': thumbnail_image}, data=data, headers=headers)

            #empty_dir(video_path)
            #empty_dir(file_path)
            os.remove(file_name) 
            print('REMOVED FILE') 

            return Response({"Message": "Added song to existing channel"})

        else:
            create_artist = Artist()
            create_artist.name = artist_name
            create_artist.channel_id = "fuck it"
            create_artist.save()

            print('Created artist')

            my_path = os.path.dirname(os.path.abspath(__file__))
            video_path = os.path.join(my_path, 'videos')
            print('got here')

            ydl_opts = {
                    'restrictfilenames': 'true'
                    }

            with youtube_dl.YoutubeDL(ydl_opts) as ydl:
                info = ydl.extract_info(youtube_url, download=True)
                file_name = ydl.prepare_filename(info)

            current_path = os.path.dirname(os.path.abspath(__file__))
            file_path = os.path.join(current_path, 'thumbnails')
            thumbnail_image_path = check_image_type(thumbnail_url, file_path)
            media_file = open(file_name, 'rb')
            thumbnail_image = open(thumbnail_image_path, 'rb')

            user_file = User.objects.get(id=1)
            token_admin = Token.objects.get_or_create(user=user_file)

            data = {
                    'name': song_title,
                    'video_url': youtube_url
                    }

            headers = {
                    "Authorization": "Token {}".format(token_admin[0])
                    }

            print('hitting endpoint')
            artist_request = requests.post('http://{}:8000/music/sync/{}/'.format(client_ip, create_artist.pk), files={'media_file': media_file, 'thumbnail': thumbnail_image}, data=data, headers=headers)
            print(artist_request.status_code)

            empty_dir(file_path)
            os.remove(file_name)
            print('Removed file') 

            return Response({"Message": "Created new artist and song"})




