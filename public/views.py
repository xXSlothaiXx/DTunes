from django.shortcuts import render
from music.models import Artist, Song
from mobile.serializers import ViewSongSerializer
from .serializers import ViewPublicPlaylistSerializer, ViewPublicArtistSerializer, ViewPublicSongSerializer
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
from users.models import Playlist

@permission_classes((AllowAny,)) 
class SongView(APIView):
    def get(self, request, format=None):
        songs = Song.objects.all().order_by('-plays')[:60] 
        serializer = ViewPublicSongSerializer(songs, many=True)
        return Response(serializer.data)

@permission_classes((AllowAny,)) 
class ArtistView(APIView):
    def get(self, request, format=None):
        artists = Artist.objects.all()[:30] 
        serializer = ViewPublicArtistSerializer(artists, many=True)
        return Response(serializer.data)


@permission_classes((AllowAny,)) 
class PlaylistView(APIView):
    def get(self, request, format=None):
        playlists = Playlist.objects.all()
        serializer = ViewPublicPlaylistSerializer(playlists, many=True)
        return Response(serializer.data)

@permission_classes((AllowAny,)) 
class ArtistDetailView(APIView):
    def get(self, request, pk, format=None):
        follow_status = 'Follow' 
        artist = Artist.objects.get(pk=pk)
        name = artist.name
        picture = artist.picture.url
        return Response({"name": name, "picture": picture})

@permission_classes((AllowAny,)) 
class SongArtistView(APIView):
    def get(self, request, pk, format=None):
        songs = Song.objects.filter(artist=pk).order_by('-plays')
        serializer = ViewSongSerializer(songs, context={"request": request}, many=True)
        return Response(serializer.data)


@permission_classes((AllowAny,)) 
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


@permission_classes((AllowAny,)) 
class ArtistsSongsView(APIView):

    def get_object(self, pk):
        try:
            return Artist.objects.get(pk=pk)
        except Artist.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        artist = self.get_object(pk) 
        songs = Song.objects.filter(artist=artist).order_by('-plays')
        serializer = ViewSongSerializer(songs, context={"request": request}, many=True)
        return Response(serializer.data)


class SongSearch(generics.ListCreateAPIView):
    search_fields = ['name']
    filter_backends = (filters.SearchFilter,)
    queryset = Song.objects.all()
    serializer_class = ViewSongSerializer
