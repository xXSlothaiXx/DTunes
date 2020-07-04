from django.db import models
from django.utils import timezone
from django.contrib.auth.models import User
from django.conf import settings

# Create your models here.

class ArtistManager(models.Manager): 

    def artist_test(self, name):
        artist = self.create(name=name) 
        return artist 
    
    #check to see if the user is following the artist
    def check_following(self, pk):
        artist = self.objects.get(pk=pk)
        if request.user in artist.followers.all():
            follow_status =  'Following'
        else:
            follow_status = 'Follow' 

        return follow_status 
   
    def get_top_artists(self):
        artists = self.objects.all().order_by('-date_posted') 
        return artists

    def get_followed_artists(self):
        artists = self.objects.get(followers=request.user).order_by('-date_posted') 
        return artists

    def get_artist_songs(self, pk):
        songs = self.objects.filter(artist=pk).order_by('-date_posted')
        return songs

    def get_top_artist_songs(self, pk):
        songs = self.objects.filter(artist=pk).order_by('-plays') 
        return songs

        
class Artist(models.Model):
    name = models.CharField(max_length=200)
    channel_id = models.CharField(max_length=200, default='channelid')
    picture = models.ImageField(default='artists/default.jpg', upload_to='api_artists')
    date_posted = models.DateTimeField(default=timezone.now)
    followers = models.ManyToManyField(settings.AUTH_USER_MODEL, blank=True, related_name='apifollowers')


    objects = ArtistManager()

    class Meta:
        ordering = ['date_posted']

    def __str__(self):
        return 'Artist {}'.format(self.name)



