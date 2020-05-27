from django.shortcuts import render
from .models import Playlist
from .serializers import ViewPlaylistSerializer
from django.shortcuts import render
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

# Create your views here.


class PlaylistView(APIView):
    def get(self, request, format=None):
        playlists = Playlist.objects.all()
        serializer = ViewPlaylistSerializer(playlists, many=True)
        return Response(serializer.data)
