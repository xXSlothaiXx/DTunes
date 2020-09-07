from django.conf.urls import url, include
from rest_framework.urlpatterns import format_suffix_patterns
from . import views




##############################
#Registration routes
##############################
register_urlpatterns = [
    url(r'^register/', views.RegisterView.as_view(), name='register-view'),
    url(r'^users/', views.UserView.as_view(), name='users-view'),

]


##############################
#Device song routes
##############################
song_urlpatterns = [

    url(r'^search/$', views.SongSearch.as_view(), name='songs-search'),
    url(r'^songs/', views.SongsView.as_view(), name='songs-view'),
    url(r'^sync/', views.SongSync.as_view(), name='songs-sync'),
    url(r'^song/(?P<pk>[\w-]+)/$', views.SongDetailView.as_view(), name='song-detail'),
    url(r'^song-playlist/(?P<pk>[\w-]+)/$', views.SongPlaylistView.as_view(), name='song-playlist'),
    url(r'^top-songs/', views.TopSongs().as_view(), name='top-songs'),
]

########################################
#Public access songs from other devices
########################################
public_song_urlpatterns = [
    url(r'^public-songs/', views.PublicSongs().as_view(), name='public-songs'),
    url(r'^public-song/(?P<pk>[\w-]+)/$', views.PublicSongDetailView.as_view(), name='public-song-detail'),
    url(r'^search/$', views.PublicSongSearch.as_view(), name='public-songs-search'),

]



####################################################
#Device playlist routes (Only auth user has access) 
####################################################
playlist_urlpatterns = [
    url(r'^playlists/', views.PlaylistsView.as_view(), name='plalyists-view'),
    url(r'^playlist/(?P<pk>[\w-]+)/$', views.PlaylistView.as_view(), name='playlist-detail'),
    url(r'^playlist-add/(?P<pk>[\w-]+)/$', views.AddSongToPlaylist.as_view(), name='playlist-songs'),
    url(r'^playlist-remove/(?P<pk>[\w-]+)/$', views.RemoveSongFromPlaylist.as_view(), name='playlist-actions'),
]


####################
# Application URLs #
####################
urlpatterns = [
    url(r'^auth/', include(register_urlpatterns)),
    url(r'^songs/', include(song_urlpatterns)),
    url(r'^songs-public/', include(public_song_urlpatterns)),
    url(r'^playlists/', include(playlist_urlpatterns)),
]


urlpatterns = format_suffix_patterns(urlpatterns)

