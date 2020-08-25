// To parse this JSON data, do
//
//     final artists = artistsFromJson(jsonString);

import 'dart:convert';

List<Artists> artistsFromJson(String str) => List<Artists>.from(json.decode(str).map((x) => Artists.fromJson(x)));

String artistsToJson(List<Artists> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Artists {
    Artists({
        this.name,
        this.datePosted,
        this.picture,
        this.id,
    });

    String name;
    DateTime datePosted;
    String picture;
    int id;

    factory Artists.fromJson(Map<String, dynamic> json) => Artists(
        name: json["name"],
        datePosted: DateTime.parse(json["date_posted"]),
        picture: json["picture"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "date_posted": datePosted.toIso8601String(),
        "picture": picture,
        "id": id,
    };
}
