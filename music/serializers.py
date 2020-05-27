from rest_framework import serializers
import base64
from drf_extra_fields.fields import Base64ImageField
from rest_framework.validators import UniqueValidator
from .models import Artist, Song 

class ViewArtistSerializer(serializers.ModelSerializer):

    class Meta:
        model = Artist
        fields = ('name', 'date_posted', 'picture')


class ViewSongSerializer(serializers.ModelSerializer):

    class Meta:
        model = Song
        fields = ('name', 'date_posted', 'media_file', 'artist')

class UploadSongSerializer(serializers.ModelSerializer):
  
      class Meta:
          model = Song
          fields = ('name', 'date_posted', 'media_file', 'thumbnail', 'video_id')



