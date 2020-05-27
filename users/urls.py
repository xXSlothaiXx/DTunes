from django.contrib import admin
from django.conf.urls import url, include
from . import views

urlpatterns = [
	#register route
    url(r'^playlists/', views.PlaylistView.as_view(), name='playlist-view'),

]
