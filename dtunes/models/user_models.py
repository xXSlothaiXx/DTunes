from django.db import models
from django.utils import timezone
from dtunes.models import Song
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

class PlaylistManager(models.Manager):
    
    #Need to add exceptions in case of errors
    def get_playlist_songs(self, pk):
        playlist = self.objects.get(pk=pk)
        songs = playlist.songs.all()
        return songs

    def add_song_to_playlist(self, pk, songid):
        playlist = self.objects.get(pk=pk)
        playlist.songs.add(songid)
        return playlist
    
    def remove_song_from_playlist(self, pk, songid):
        playlist = self.objects.get(pk=pk)
        playlist.songs.remove(songid)
        return playlist

class Playlist(models.Model):
    user = models.ForeignKey(User, related_name="apiplaylistuser", on_delete=models.CASCADE)
    name = models.CharField(max_length=200)
    picture = models.ImageField(default='playlists/default.png', upload_to='playlists')
    songs = models.ManyToManyField(Song, related_name='apiplaylistsongs', blank=True)
    date_posted = models.DateTimeField(default=timezone.now) 

    objects = PlaylistManager()

    class Meta:
        ordering = ['date_posted']

    def __str__(self):
        return 'Playlist {} for {}'.format(self.name, self.user.username)
