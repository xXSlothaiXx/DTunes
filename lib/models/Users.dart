// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

List<Users> usersFromJson(String str) => List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
    Users({
        this.username,
        this.id,
    });

    String username;
    int id;

    factory Users.fromJson(Map<String, dynamic> json) => Users(
        username: json["username"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "id": id,
    };
}