// To parse this JSON data, do
//
//     final song = songFromJson(jsonString);

import 'dart:convert';

Song songFromJson(String str) => Song.fromJson(json.decode(str));

String songToJson(Song data) => json.encode(data.toJson());

class Song {
    Song({
        this.name,
        this.datePosted,
        this.mediaFile,
        this.artist,
        this.thumbnail,
        this.id,
        this.plays,
        this.artistname,
    });

    String name;
    DateTime datePosted;
    String mediaFile;
    int artist;
    String thumbnail;
    int id;
    int plays;
    String artistname;

    factory Song.fromJson(Map<String, dynamic> json) => Song(
        name: json["name"],
        datePosted: DateTime.parse(json["date_posted"]),
        mediaFile: json["media_file"],
        artist: json["artist"],
        thumbnail: json["thumbnail"],
        id: json["id"],
        plays: json["plays"],
        artistname: json["artistname"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "date_posted": datePosted.toIso8601String(),
        "media_file": mediaFile,
        "artist": artist,
        "thumbnail": thumbnail,
        "id": id,
        "plays": plays,
        "artistname": artistname,
    };
}