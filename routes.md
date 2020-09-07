#Songs(Authenticated route for owner) 
/dtunes/songs/songs/
/dtunes/songs/song/<id>/
/dtunes/songs/song-playlist/<id>/
/dtunes/songs/artist-songs/<id>/ 
/dtunes/songs/top-songs/

#Public song(for other devices) 
/dtunes/public/songs/
/dtunes/public/song/<id>/
/dtunes/public/artist-songs/<artist_id>/
/dtunes/public/search-song/$searchterm/
/dtunes/public/artists/
/dtunes/public/artists/<id>/
/dtunes/public/artist-actions/<artistid>/

#Artists(Authenticated route for owner) 
/dtunes/artists/artists/
/dtunes/artists/artist/<id>/ 
/dtunes/artists/artist-actions/<id>/ 

#Playlists(Permission route) 
/dtunes/playlists/playlists/
/dtunes/playlists/playlist/<id>/
/dtunes/playlists/playlist-add/<id>/
/dtunes/playlists/playlist-remove/<id>/ 

#Register
/dtunes/auth/register/
/dtunes/auth/users/

