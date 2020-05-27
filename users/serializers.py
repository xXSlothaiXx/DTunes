
from rest_framework import serializers
import base64
from drf_extra_fields.fields import Base64ImageField
from rest_framework.validators import UniqueValidator
from .models import Profile, Playlist 
from django.contrib.auth.models import User

class ProfileSerializer(serializers.ModelSerializer):

    class Meta:
        model = Profile
        fields = ('image')


class CreatePlaylistSerializer(serializers.ModelSerializer):
    picture = Base64ImageField(required=False)

    class Meta:
        model = Playlist
        fields = ('name')


class ViewPlaylistSerializer(serializers.ModelSerializer):

    user = serializers.SlugRelatedField(slug_field="username", queryset= User.objects.all())

    class Meta:
        model = Playlist
        fields = ('user', 'name', 'picture', 'date_posted', 'id')
