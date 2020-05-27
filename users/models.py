from django.db import models
from django.utils import timezone
from music.models import Song
from django.conf import settings
from django.contrib.auth.models import User
# Create your models here.


class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    image = models.ImageField(default='default.jpg', upload_to='profile_pics')
    profile_pic_url = models.CharField(max_length=200, blank=True)
    bio = models.TextField(max_length=300, null=True)

    def __str__(self):
        return  '{} Profile'.format(self.user.username)


class Playlist(models.Model):
    user = models.ForeignKey(User, related_name="playlistuser", on_delete=models.CASCADE)
    name = models.CharField(max_length=200)
    picture = models.ImageField(default='playlists/default.jpg', upload_to='artists')
    songs = models.ManyToManyField(Song, related_name='playlistsongs', blank=True)
    date_posted = models.DateTimeField(default=timezone.now) 

    class Meta:
        ordering = ['date_posted']

    def __str__(self):
        return 'Playlist {} for {}'.format(self.name, self.user.username)
