from django.contrib import admin
from django.conf.urls import url, include
from . import views

urlpatterns = [

    url(r'^songs/', views.SongView.as_view(), name='public-songs'),
    url(r'^artists/', views.ArtistView.as_view(), name='public-artists'),
    url(r'^playlists/', views.PlaylistView.as_view(), name='public-playlists'),
    url(r'^artist/(?P<pk>[\w-]+)/$', views.ArtistDetailView.as_view(), name='public-artist'),
    url(r'^artist-songs/(?P<pk>[\w-]+)/$', views.SongArtistView.as_view(), name='song-artist'),
    url(r'^player/(?P<pk>[\w-]+)/$', views.SongDetailView.as_view(), name='song-detail'),
    url(r'^artistrelatedsongs/(?P<pk>[\w-]+)/$', views.ArtistsSongsView.as_view(), name='artist-related-songs'), 
    url(r'^searchsong/$', views.SongSearch.as_view(), name='search-song'),

]
