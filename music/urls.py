from django.conf.urls import url
from rest_framework.urlpatterns import format_suffix_patterns
from . import views


urlpatterns = [
    #lists

    url(r'^youtube/', views.GetYTAPIKey.as_view(), name='youtube-api'),
    url(r'^api-token/', views.ConfigureAPIToken.as_view(), name='api-token'),
    url(r'^search/$', views.SearchSongs.as_view(), name='search-songs'),
    url(r'^system/', views.SystemInfo.as_view(), name='system-info'),
    url(r'^account/', views.SuperUser.as_view(), name='superuser'),
    url(r'^addsong/', views.SyncSong.as_view(), name='sync-song'),
    url(r'^music/', views.MusicView.as_view(), name='view-music'),
    url(r'^sync/(?P<pk>[\w-]+)/$', views.ArtistSync.as_view(), name="artist-    sync"),

]

urlpatterns = format_suffix_patterns(urlpatterns)
