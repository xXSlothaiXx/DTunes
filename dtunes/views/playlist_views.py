from django.shortcuts import render
from dtunes.models import Artist, Song, Playlist, Profile
from dtunes.serializers import RegistrationSerializer, ViewUserSerializer, CreateArtistPhotoSerializer, CreateArtistSerializer, CreatePlaylistPhotoSerializer, CreatePlaylistSerializer, ViewPlaylistSerializer, ViewArtistSerializer, ViewSongSerializer
from django.shortcuts import render
from rest_framework.views import APIView
from django.http import HttpResponse, Http404
from rest_framework.response import Response
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





#Create, Read, Update, Delete Playlist
class PlaylistsView(APIView):

    def get(self, request, format=None):
        playlists = Playlist.objects.all()
        serializer = ViewPlaylistSerializer(playlists, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        context = {"reuquest": request}
        serializer = CreatePlaylistSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.save(user=request.user)
            return Response({"Message": "Created Playlist"}) 
        else:
            return Response({"Message": "Failed to create playlist"}) 


class PlaylistView(APIView):


    def get_object(self, pk):
        try:
            return Playlist.objects.get(pk=pk)
        except Playlist.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        playlist = self.get_object(pk)
        serializer = ViewPlaylistSerializer(playlist)
        return Response(serializer.data)

    def put(self, request, pk, format=None):
         playlist = self.get_object(pk) 
         serializer = CreatePlaylistPhotoSerializer(playlist, data=request.data)
         if serializer.is_valid(raise_exception=True):
            serializer.save(user=request.user)
            return Response({"message": "updated playlist photo"})

    def delete(self, request, pk, format=None):
        playlist = self.get_object(pk)
        playlist.delete()
        return Response({"Message": "Playlist was deleted"})


class AddSongToPlaylist(APIView):


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


class RemoveSongFromPlaylist(APIView):

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





