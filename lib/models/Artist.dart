// To parse this JSON data, do
//
//     final artist = artistFromJson(jsonString);

import 'dart:convert';

Artist artistFromJson(String str) => Artist.fromJson(json.decode(str));

String artistToJson(Artist data) => json.encode(data.toJson());

class Artist {
    Artist({
        this.name,
        this.picture,
        this.followStatus,
    });

    String name;
    String picture;
    String followStatus;

    factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        name: json["name"],
        picture: json["picture"],
        followStatus: json["follow_status"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "picture": picture,
        "follow_status": followStatus,
    };
}