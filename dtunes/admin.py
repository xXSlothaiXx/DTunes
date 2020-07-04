from django.contrib import admin
from dtunes.models import Song, Artist, Playlist, Profile

admin.site.register(Song)
admin.site.register(Artist)
admin.site.register(Playlist)
admin.site.register(Profile)

