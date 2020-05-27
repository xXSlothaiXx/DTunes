from django.contrib import admin
from django.conf.urls import url, include
from . import views

urlpatterns = [
	#register route

    url(r'^register/', views.RegisterView.as_view(), name='register-view'),
    url(r'^playlists/', views.UserPlaylistView.as_view(), name='playlist-view'),
    url(r'^artists/', views.ArtistView.as_view(), name='artists-view'),
    url(r'^songs/', views.SongsView.as_view(), name='songs-view'),
    url(r'^topsongs/', views.TopSongsView.as_view(), name='top-songs-view'),
    url(r'^createartist/', views.CreateArtistView.as_view(), name='create-artist'),

    url(r'^create/', views.CreatePlaylistView.as_view(), name='create-view'),
    url(r'^artist/(?P<pk>[\w-]+)/$', views.ArtistDetailView.as_view(), name="artist-detail"),
    url(r'^song/(?P<pk>[\w-]+)/$', views.SongDetailView.as_view(), name="song-detail"),

    url(r'^playsong/(?P<pk>[\w-]+)/$', views.PlaySongView.as_view(), name="play-song"),
    url(r'^playlist/(?P<pk>[\w-]+)/$', views.PlaylistDetailView.as_view(), name="playlist-detail"),

    url(r'^artistsongs/(?P<pk>[\w-]+)/$', views.SongArtistView.as_view(), name="artist-songs"),


    url(r'^psongs/(?P<pk>[\w-]+)/$', views.SongPlaylistView.as_view(), name="playlist-detail"),

    url(r'^addsong/(?P<pk>[\w-]+)/$', views.AddSongView.as_view(), name="add-song"),

    url(r'^removesong/(?P<pk>[\w-]+)/$', views.RemoveSongView.as_view(), name="remove-song"),

    url(r'^removeplaylist/(?P<pk>[\w-]+)/$', views.RemovePlaylistView.as_view(), name="remove-playlist"),
    url(r'^playlistphoto/(?P<pk>[\w-]+)/$', views.PlaylistPhotoView.as_view(), name="playlist-photo"),

    url(r'^artistphoto/(?P<pk>[\w-]+)/$', views.ArtistPhotoView.as_view(), name="artist-photo"),



    url(r'^artistrelatedsongs/(?P<pk>[\w-]+)/$', views.ArtistsSongsView.as_view(), name="related-artists-song"),


    url(r'^follow/(?P<pk>[\w-]+)/$', views.FollowArtistView.as_view(), name="follow-artist"),
    url(r'^search/', views.ArtistSearch.as_view(), name='search-artist'),

    url(r'^searchsong/', views.SongSearch.as_view(), name='search-song'),

    url(r'^network-songs/', views.PublicSongs.as_view(), name='public-song'),

    url(r'^network-artists/', views.PublicArtists.as_view(), name='public-artist'),

    url(r'^network-playlists/', views.PublicPlaylists.as_view(), name='public-playlists'),

    url(r'^network-users/', views.UserView.as_view(), name='public-users'),
]
