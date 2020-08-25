import 'database_creator.dart';


class Network {
  int id;
  String name;
  String network;

  Network(this.id, this.name, this.network);

  Network.fromJson(Map<String, dynamic> json) {
    this.id = json[DatabaseCreator.id];
    this.name = json[DatabaseCreator.name];
    this.network = json[DatabaseCreator.network];
  }
}