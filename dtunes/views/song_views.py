from django.shortcuts import render
from dtunes.models import  Song, Playlist, Profile
from dtunes.serializers import *
#from dtunes.serializers import RegistrationSerializer, ViewUserSerializer, CreateArtistPhotoSerializer, CreateArtistSerializer, CreatePlaylistPhotoSerializer, CreatePlaylistSerializer, ViewPlaylistSerializer, ViewArtistSerializer, ViewSongSerializer
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


class SongSearch(generics.ListCreateAPIView):
    search_fields = ['name']
    filter_backends = (filters.SearchFilter,)
    queryset = Song.objects.all()
    serializer_class = ViewSongSerializer

class SongsView(APIView):

    def get(self, request, format=None):
        songs = Song.objects.all()
        serializer = ViewSongSerializer(songs, context={"request": request}, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        youtube_url = request.data['video_url']
        song = Song.objects.sync_song(youtube_url)
        return Response({"Message": song})



class TopSongs(APIView):
    def get(self, request, format=None):
        songs = Song.objects.all().order_by('-plays')
        serializer = ViewSongSerializer(songs, context={"request": request}, many=True)
        return Response(serializer.data)


class SongDetailView(APIView):

    def get_object(self, pk):
        try:
            return Song.objects.get(pk=pk)
        except Song.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        song = self.get_object(pk)
        song.plays = song.plays + 1
        song.save()
        serializer = ViewSongSerializer(song)
        return Response(serializer.data)


class SongSync(APIView):
    def post(self, request, format=None):
        serializer = UploadSongSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.save()
            return Response({"message": "created song"})
        else:
            return Response({"Message": "you failed"})


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

###############################
#PUBLIC SONG VIEWS
###############################

@permission_classes((AllowAny,))
class PublicSongDetailView(APIView):
    def get_object(self, pk):
        try:
            return Song.objects.get(pk=pk)
        except Song.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        song = self.get_object(pk)
        serializer = ViewSongSerializer(song)
        return Response(serializer.data)


@permission_classes((AllowAny,))
class PublicSongs(APIView):
    def get(self, request, format=None):
        songs = Song.objects.all().order_by('-plays')[:60]
        serializer = ViewPublicSongSerializer(songs, many=True)
        return Response(serializer.data)


class PublicSongSearch(generics.ListCreateAPIView):
    search_fields = ['name']
    filter_backends = (filters.SearchFilter,)
    queryset = Song.objects.all()
    serializer_class = ViewSongSerializer
