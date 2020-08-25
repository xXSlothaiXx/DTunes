// To parse this JSON data, do
//
//     final playlists = playlistsFromJson(jsonString);

import 'dart:convert';

List<Playlists> playlistsFromJson(String str) => List<Playlists>.from(json.decode(str).map((x) => Playlists.fromJson(x)));

String playlistsToJson(List<Playlists> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Playlists {
    Playlists({
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

    factory Playlists.fromJson(Map<String, dynamic> json) => Playlists(
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
