import 'package:flutter/widgets.dart';
import 'package:music_app/src/RouteMeDBModels/TransportType.dart';

class Transport{

  int id;
  int capacity;
  int typeId;
  TransportType type;

  Transport({this.id, @required this.capacity, @required this.typeId});

  factory Transport.fromJson (Map<String, dynamic> json) => new Transport(
    id          : json["id"],
    capacity    : json["capacity"],
    typeId      : json["typeId"]
  );

  Map<String, dynamic> toJson() => {
    "capacity"    : this.capacity,
    "typeId"    : this.typeId,
  };

  @override
  String toString() => ("ID: $id \nCapacidad $capacity \n${type.toString()}");
}