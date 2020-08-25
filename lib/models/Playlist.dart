// To parse this JSON data, do
//
//     final playlist = playlistFromJson(jsonString);

import 'dart:convert';

Playlist playlistFromJson(String str) => Playlist.fromJson(json.decode(str));

String playlistToJson(Playlist data) => json.encode(data.toJson());

class Playlist {
    Playlist({
        this.user,
        this.name,
        this.picture,
        this.datePosted,
        this.id,
    });

    String user;
    String name;
    String picture;
    DateTime datePosted;
    int id;

    factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        user: json["user"],
        name: json["name"],
        picture: json["picture"],
        datePosted: DateTime.parse(json["date_posted"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "name": name,
        "picture": picture,
        "date_posted": datePosted.toIso8601String(),
        "id": id,
    };
}