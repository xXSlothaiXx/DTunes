from rest_framework import serializers
import base64
from drf_extra_fields.fields import Base64ImageField
from rest_framework.validators import UniqueValidator
from music.models import Artist, Song
from users.models import Profile, Playlist
from django.contrib.auth.models import User



class RegistrationSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(required=True, validators=[UniqueValidator(queryset=User.objects.all())])
    username = serializers.CharField(validators=[UniqueValidator(queryset=User.objects.all())])
    password = serializers.CharField(min_length=8)

    class Meta:
        model = User
        fields = ( 'id' , 'username', 'email', 'password')

    def create(self, validated_data):
        user = super(RegistrationSerializer, self).create(validated_data)
        user.set_password(validated_data['password'])
        user.save()
        return user

class ViewUserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ('username', 'id')

class ViewArtistSerializer(serializers.ModelSerializer):

    class Meta:
        model = Artist
        fields = ('name', 'date_posted', 'picture', 'id')

class ViewSongSerializer(serializers.ModelSerializer):
    artistname = serializers.SlugRelatedField(slug_field="name", queryset= Artist.objects.all())

    class Meta:
        model = Song
        fields = ('name', 'date_posted', 'media_file', 'artist', 'thumbnail', 'id', 'plays', 'artistname')

class UploadSongSerializer(serializers.ModelSerializer):
  
      class Meta:
          model = Song
          fields = ('name', 'date_posted', 'media_file', 'thumbnail')

class ProfileSerializer(serializers.ModelSerializer):

    class Meta:
        model = Profile
        fields = ('image')


class CreatePlaylistSerializer(serializers.ModelSerializer):

    class Meta:
        model = Playlist
        fields = ('name',)


class ViewPlaylistSerializer(serializers.ModelSerializer):

    user = serializers.SlugRelatedField(slug_field="username", queryset= User.objects.all())

    class Meta:
        model = Playlist
        fields = ('user', 'name', 'picture', 'date_posted', 'id')


class CreatePlaylistPhotoSerializer(serializers.ModelSerializer):
    picture = Base64ImageField(required=False)

    class Meta:
        model = Playlist
        fields = ('picture',)

class CreateArtistPhotoSerializer(serializers.ModelSerializer):
    picture = Base64ImageField(required=False)

    class Meta:
        model = Artist
        fields = ('picture',)


class CreateArtistSerializer(serializers.ModelSerializer):
    picture = Base64ImageField(required=False)
    class Meta:
        model = Artist
        fields = ('name', 'picture', 'channel_id')
