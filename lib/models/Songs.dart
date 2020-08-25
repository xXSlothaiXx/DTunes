// To parse this JSON data, do
//
//     final songs = songsFromJson(jsonString);

import 'dart:convert';

List<Songs> songsFromJson(String str) => List<Songs>.from(json.decode(str).map((x) => Songs.fromJson(x)));

String songsToJson(List<Songs> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Songs {
    Songs({
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

    factory Songs.fromJson(Map<String, dynamic> json) => Songs(
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