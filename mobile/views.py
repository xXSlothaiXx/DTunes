from django.shortcuts import render
from users.models import Playlist
from music.models import Artist, Song
from .serializers import RegistrationSerializer, ViewUserSerializer, CreateArtistPhotoSerializer, CreateArtistSerializer, CreatePlaylistPhotoSerializer, CreatePlaylistSerializer, ViewPlaylistSerializer, ViewArtistSerializer, ViewSongSerializer
from django.shortcuts import render
from rest_framework.views import APIView
from django.http import HttpResponse, Http404
from rest_framework.response import Response
from apiclient.discovery import build
from pytube import YouTube
import json
import requests
import os
import urllib.request
from rest_framework import generics
from rest_framework import filters
from django.contrib.auth.models import User
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.decorators import permission_classes
from rest_framework.authtoken.models import Token

api_key = "AIzaSyBxpiwthtXp5OUBFCF2ltn1uh-0q3n5gk4"
youtube = build('youtube', 'v3', developerKey=api_key)

# Create your views here.


#user registration view
@permission_classes((AllowAny,)) 
class RegisterView(APIView):
    def get(self, request):
        return Response({"message": "This view works"})

    def post(self, request):
        if request.method == "POST":
            serializer = RegistrationSerializer(data=request.data)
            if serializer.is_valid(raise_exception=True):
                user = serializer.save()
                if user:
                    token = Token.objects.create(user=user)
                    json = serializer.data
                    return Response(json) 


class ArtistSearch(generics.ListCreateAPIView):
    search_fields = ['name']
    filter_backends = (filters.SearchFilter,)
    queryset = Artist.objects.all()
    serializer_class = ViewArtistSerializer


class SongSearch(generics.ListCreateAPIView):
    search_fields = ['name']
    filter_backends = (filters.SearchFilter,)
    queryset = Song.objects.all()
    serializer_class = ViewSongSerializer


class PlaylistView(APIView):
    def get(self, request, format=None):
        playlists = Playlist.objects.all()
        serializer = ViewPlaylistSerializer(playlists, many=True)
        return Response(serializer.data)


class UserPlaylistView(APIView):
    def get(self, request, format=None):
        playlists = Playlist.objects.filter(user=request.user)
        serializer = ViewPlaylistSerializer(playlists, many=True)
        return Response(serializer.data)

class UserView(APIView):
    def get(self, request, format=None):
        users = User.objects.all()
        serializer = ViewUserSerializer(users, many=True) 
        return Response(serializer.data) 

class ArtistDetailView(APIView):
    def get(self, request, pk, format=None):
        follow_status = 'Follow' 
        artist = Artist.objects.get(pk=pk)
        if request.user in artist.followers.all():
            follow_status = 'Following' 
        name = artist.name
        picture = artist.picture.url
        return Response({"name": name, "picture": picture, "follow_status": follow_status})

class SongDetailView(APIView):

    def get_object(self, pk):
        try:
            return Song.objects.get(pk=pk)
        except Song.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        song = self.get_object(pk)
        serializer = ViewSongSerializer(song) 
        return Response(serializer.data)

class PlaySongView(APIView):

    def get_object(self, pk):
        try:
            return Song.objects.get(pk=pk)
        except Song.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        song = self.get_object(pk)
        song.plays = song.plays + 1
        song.save() 
        return Response({"message":"Increased count"})

class SongArtistView(APIView):

    def get(self, request, pk, format=None):
        songs = Song.objects.filter(artist=pk).order_by('-date_posted')
        serializer = ViewSongSerializer(songs, context={"request": request}, many=True)
        return Response(serializer.data)



class ArtistView(APIView):

    def get(self, request, format=None):
        songs = Artist.objects.filter(followers=request.user).order_by('-date_posted')
        serializer = ViewArtistSerializer(songs, context={"request": request}, many=True)
        return Response(serializer.data)


class SongsView(APIView):

    def get(self, request, format=None):
        artists = Artist.objects.filter(followers=request.user)  
        songs = Song.objects.filter(artist__in=artists).order_by('-plays')
        serializer = ViewSongSerializer(songs, context={"request": request}, many=True)
        return Response(serializer.data)


class PublicArtists(APIView):
    def get(self, request, format=None):
        artists = Artist.objects.all().order_by('-date_posted') 
        serializer = ViewArtistSerializer(artists, context={"request": request}, many=True) 
        return Response(serializer.data) 


class PublicSongs(APIView):
    def get(self, request, format=None):
        songs = Song.objects.all().order_by('-date_posted') 
        serializer = ViewSongSerializer(songs, context={"request": request}, many=True) 
        return Response(serializer.data) 


class PublicPlaylists(APIView):
    def get(self, request, format=None):
        playlists = Playlist.objects.all().order_by('-date_posted') 
        serializer = ViewPlaylistSerializer(playlists, context={"request": request}, many=True) 
        return Response(serializer.data) 

class TopSongsView(APIView):

    def get(self, request, format=None):
        songs = Song.objects.all().order_by('-plays')
        serializer = ViewSongSerializer(songs, context={"request": request}, many=True)
        return Response(serializer.data)

class PlaylistDetailView(APIView):

    def get_object(self, pk):
        try:
            return Playlist.objects.get(pk=pk)
        except Playlist.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        playlist = self.get_object(pk)
        serializer = ViewPlaylistSerializer(playlist) 
        return Response(serializer.data)



class SongPlaylistView(APIView):


    def get_object(self, pk):
        try:
            return Playlist.objects.get(pk=pk)
        except Playlist.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        playlist = self.get_object(pk) 
        songs = playlist.songs.all() 
        serializer = ViewSongSerializer(songs, context={"request": request}, many=True)
        return Response(serializer.data)


class AddSongView(APIView):


    def get_object(self, pk):
        try:
            return Playlist.objects.get(pk=pk)
        except Playlist.DoesNotExist:
            raise Http404

    def post(self, request, pk, format=None):
        playlist = self.get_object(pk) 
        songid = request.data['songid']
        playlist.songs.add(songid) 
        return Response({"Message": "Added song to playlist"})


class RemoveSongView(APIView):

    def get_object(self, pk):
        try:
            return Playlist.objects.get(pk=pk)
        except Playlist.DoesNotExist:
            raise Http404

    def post(self, request, pk, format=None):
        playlist = self.get_object(pk) 
        songid = request.data['songid']
        playlist.songs.remove(songid) 
        return Response({"Message": "Removed Song FROM  playlist"})


class RemovePlaylistView(APIView):

    def get_object(self, pk):
        try:
            return Playlist.objects.get(pk=pk)
        except Playlist.DoesNotExist:
            raise Http404

    def post(self, request, pk, format=None):
        playlist = self.get_object(pk) 
        playlist.delete() 
        return Response({"Message": "Playlist was deleted"})

class CreatePlaylistView(APIView):
     def post(self, request, format=None):
         context={"request": request}
         if request.method == "POST":
            serializer = CreatePlaylistSerializer(data=request.data)
            if serializer.is_valid(raise_exception=True):
               serializer.save(user=request.user)
               return Response({"message": "created post"})


class PlaylistPhotoView(APIView):
     def put(self, request, pk, format=None):
         playlist = Playlist.objects.get(pk=pk)
         serializer = CreatePlaylistPhotoSerializer(playlist, data=request.data)
         if serializer.is_valid(raise_exception=True):
            serializer.save(user=request.user)
            return Response({"message": "updated playlist photo"})



class ArtistPhotoView(APIView):
     def put(self, request, pk, format=None):
         artist = Artist.objects.get(pk=pk)
         serializer = CreateArtistPhotoSerializer(artist, data=request.data)
         if serializer.is_valid(raise_exception=True):
            serializer.save()
            return Response({"message": "updated artist photo"})

#get rid of this view
class CreateArtistView(APIView):
     def post(self, request, format=None):
         context={"request": request}
         if request.method == "POST":
            serializer = CreateArtistSerializer(data=request.data)
            if serializer.is_valid(raise_exception=True):
               serializer.save()
               return Response({"message": "created artist"})




#Aritst player detail queries


class ArtistsSongsView(APIView):

    def get_object(self, pk):
        try:
            return Artist.objects.get(pk=pk)
        except Artist.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        artist = self.get_object(pk) 
        songs = Song.objects.filter(artist=artist).order_by('-date_posted')

        serializer = ViewSongSerializer(songs, context={"request": request}, many=True)
        return Response(serializer.data)


class FollowArtistView(APIView):

    def get_object(self, pk):
        try:
            return Artist.objects.get(pk=pk)
        except Artist.DoesNotExist:
            raise Http404

    def post(self, request, pk, format=None):
        artist = self.get_object(pk) 
        artist.followers.add(request.user)
        return Response({"message": "Followed artist"})
