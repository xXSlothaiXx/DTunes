from django.shortcuts import render
from dtunes.models import Artist, Song, Playlist, Profile
from dtunes.serializers import UploadSongSerializer, RegistrationSerializer, ViewUserSerializer, CreateArtistPhotoSerializer, CreateArtistSerializer, CreatePlaylistPhotoSerializer, CreatePlaylistSerializer, ViewPlaylistSerializer, ViewArtistSerializer, ViewSongSerializer
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


class ArtistSearch(generics.ListCreateAPIView):
    search_fields = ['name']
    filter_backends = (filters.SearchFilter,)
    queryset = Artist.objects.all()
    serializer_class = ViewArtistSerializer


class ArtistsView(APIView):

    def get(self, request, format=None):
        songs = Artist.objects.all().order_by('-date_posted')
        serializer = ViewArtistSerializer(songs, context={"request": request}, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        context = {"reuquest": request}
        serializer = CreateArtistSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.save(user=request.user)
            return Resonse({"Message": "Created Artist"})
        else:
            return Response({"Message": "Failed to create Artist"})


class ArtistDetailView(APIView):

    def get_object(self, pk):
        try:
            return Artist.objects.get(pk=pk)
        except Artist.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        follow_status = 'Follow'
        artist = self.get_object(pk) 
        if request.user in artist.followers.all():
            follow_status = 'Following'
        name = artist.name
        picture = artist.picture.url
        return Response({"name": name, "picture": picture, "follow_status": follow_status})


    def post(self, request, pk, format=None):
        artist =  Artist.objects.get(pk=pk)
        context={"request": request}
        if request.method == "POST":
            serializer = UploadSongSerializer(data=request.data)
            if serializer.is_valid(raise_exception=True):
                serializer.save(artist=artist, artistname=artist)
                return Response({"message": "created song"})
            else:
                return Response({"Message": "you failed"})


    def put(self, request, pk, format=None):
         artist = Artist.objects.get(pk=pk)
         serializer = CreateArtistPhotoSerializer(artist, data=request.data)
         if serializer.is_valid(raise_exception=True):
            serializer.save()
            return Response({"message": "updated artist photo"})


class ArtistActions(APIView):

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

    def post(self, request, pk, format=None):
        artist = self.get_object(pk)
        artist.followers.add(request.user)
        return Response({"message": "Followed artist"})

#####################################
#PUBLIC ARTIST VIEWS
#####################################

@permission_classes((AllowAny,))
class PublicArtistsView(APIView):

    def get(self, request, format=None):
        artists = Artist.objects.all().order_by('-date_posted')
        serializer = ViewArtistSerializer(artists, context={"request": request}, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        context = {"reuquest": request}
        serializer = CreateArtistSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.save(user=request.user)
            return Resonse({"Message": "Created Artist"})
        else:
            return Response({"Message": "Failed to create Artist"})


@permission_classes((AllowAny,))
class PublicArtistDetail(APIView):

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

    def post(self, request, pk, format=None):
        artist = self.get_object(pk)
        context={"request": request}
        if request.method == "POST":
            serializer = UploadSongSerializer(data=request.data)
            if serializer.is_valid(raise_exception=True):

                serializer.save(artist=artist, artistname=artist)
                return Response({"message": "created song"})
            else:
                return Response({"Message": "you failed"})


