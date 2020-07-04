from django.conf.urls import url, include
from rest_framework.urlpatterns import format_suffix_patterns
from . import views


"""
urlpatterns = [

    url(r'^songs/', views.SongsView.as_view(), name='songs-view'),
    url(r'^song/(?P<pk>[\w-]+)/$', views.SongDetailView.as_view(), name='song-detail'),
    url(r'^song-playlist/', views.SongPlaylistView.as_view(), name='song-playlist'),
    url(r'^artist-songs/', views.artist_song, name='artist-songs'),
    url(r'^artists/', views.ArtistsView.as_view(), name='artists-view'),
    url(r'^artist/(?P<pk>[\w-]+)/$', views.ArtistDetailView.as_view(), name='artist-detail'),
    url(r'^artist-actions/(?P<pk>[\w-]+)/$', views.ArtistActions.as_view(), name='artist-actions'),
    url(r'^playlists/', views.PlaylistsView.as_view(), name='plalyists-view'),      
    url(r'^playlist/(?P<pk>[\w-]+)/$', views.PlaylistView.as_view(), name='playlist-detail'),
    url(r'^playlist-songs/(?P<pk>[\w-]+)/$', views.SongPlaylist.as_view(), name='playlist-songs'),
    url(r'^public-songs/', views.public_songs, name='public-songs'),
    url(r'^public-song/(?P<pk>[\w-]+)/$', views.PublicSongDetailView.as_view(), name='public-song-detail'),
    url(r'^public-artist-song/(?P<pk>[\w-]+)/$', views.public_song_artist, name='public-artist-songs'),
    url(r'^public-artists/', views.PublicArtistsViews.as_view(), name='public-artists-view'),
    url(r'^public-artist/(?P<pk>[\w-]+)/$', views.PublicArtistDetailView.as_view(), name='public-artist-detail'),

]
"""


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
    url(r'^song/(?P<pk>[\w-]+)/$', views.SongDetailView.as_view(), name='song-detail'),
    url(r'^song-playlist/(?P<pk>[\w-]+)/$', views.SongPlaylistView.as_view(), name='song-playlist'),
    url(r'^artist-songs/(?P<pk>[\w-]+)/$', views.ArtistSongs().as_view(), name='artist-songs'),
    url(r'^top-songs/', views.TopSongs().as_view(), name='top-songs'),
]

########################################
#Public access songs from other devices
########################################
public_song_urlpatterns = [
    url(r'^public-songs/', views.PublicSongs().as_view(), name='public-songs'),
    url(r'^public-song/(?P<pk>[\w-]+)/$', views.PublicSongDetailView.as_view(), name='public-song-detail'),
    url(r'^public-artist-song/(?P<pk>[\w-]+)/$', views.PublicSongArtist().as_view(), name='public-artist-songs'),
    url(r'^search/$', views.PublicSongSearch.as_view(), name='public-songs-search'),

]

########################################
#Device artist routes
########################################
artist_urlpatterns = [
    url(r'^artists/', views.ArtistsView.as_view(), name='artists-view'),
    url(r'^artist/(?P<pk>[\w-]+)/$', views.ArtistDetailView.as_view(), name='artist-detail'),
    url(r'^artist-actions/(?P<pk>[\w-]+)/$', views.ArtistActions.as_view(), name='artist-actions'),
]

#########################################
#Public access artists from other devices
#########################################
public_artist_urlpatterns = [
    url(r'^public-artists/', views.PublicArtistsView.as_view(), name='public-artists-view'),
    url(r'^public-artist/(?P<pk>[\w-]+)/$', views.PublicArtistDetail.as_view(), name='public-artist-detail'),
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
    url(r'^artists/', include(artist_urlpatterns)),
    url(r'^artists-public/', include(public_artist_urlpatterns)),
    url(r'^playlists/', include(playlist_urlpatterns)),
]


urlpatterns = format_suffix_patterns(urlpatterns)

