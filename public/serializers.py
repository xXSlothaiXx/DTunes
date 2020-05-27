from rest_framework import serializers
import base64
from drf_extra_fields.fields import Base64ImageField
from rest_framework.validators import UniqueValidator
from music.models import Artist, Song
from users.models import Profile, Playlist
from django.contrib.auth.models import User


class ViewPublicArtistSerializer(serializers.ModelSerializer):

    class Meta:
        model = Artist
        fields = ('name', 'date_posted', 'picture', 'id')

class ViewPublicSongSerializer(serializers.ModelSerializer):
    artistname = serializers.SlugRelatedField(slug_field="name", queryset= Artist.objects.all())

    class Meta:
        model = Song
        fields = ('name', 'date_posted', 'media_file', 'artist', 'thumbnail', 'id', 'plays', 'artistname')


class ViewPublicPlaylistSerializer(serializers.ModelSerializer):

    user = serializers.SlugRelatedField(slug_field="username", queryset= User.objects.all())

    class Meta:
        model = Playlist
        fields = ('user', 'name', 'picture', 'date_posted', 'id')
