from django.db import models
from django.utils import timezone
from django.contrib.auth.models import User
from django.conf import settings

# Create your models here.

class Artist(models.Model):
    name = models.CharField(max_length=200)
    channel_id = models.CharField(max_length=200, default='channelid')
    picture = models.ImageField(default='artists/default.jpg', upload_to='artists')
    date_posted = models.DateTimeField(default=timezone.now)
    followers = models.ManyToManyField(settings.AUTH_USER_MODEL, blank=True, related_name='followers')


    class Meta:
        ordering = ['date_posted']

    def __str__(self):
        return 'Artist {}'.format(self.name)


class Song(models.Model): 
    name = models.CharField(max_length=200) 
    date_posted = models.DateTimeField(default=timezone.now) 
    media_file = models.FileField(upload_to='songs')
    artist = models.ForeignKey(Artist, on_delete=models.CASCADE) 
    thumbnail = models.ImageField(default='songs/default.jpg', upload_to='songthumbnails')
    plays = models.IntegerField(default=0) 
    artistname = models.ForeignKey(Artist,related_name='artistname', on_delete=models.CASCADE) 
    video_id = models.CharField(default="video_id", max_length=50) 


    class Meta:
        ordering = ['-date_posted'] 

    def __str__(self):
        return 'Song {}'.format(self.name) 
