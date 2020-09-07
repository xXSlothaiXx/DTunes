from django.contrib import admin
from dtunes.models import Song,  Playlist, Profile, Device

admin.site.register(Song)
admin.site.register(Playlist)
admin.site.register(Profile)
admin.site.register(Device)
