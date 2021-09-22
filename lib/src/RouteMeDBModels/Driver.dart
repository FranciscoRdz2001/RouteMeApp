import 'package:flutter/widgets.dart';
import 'package:music_app/src/RouteMeDBModels/TransportType.dart';

import 'Route.dart';

class Driver{

  int id;
  String name;
  int type;
  int driverRank;
  int routeID;
  RouteM route;
  TransportType transportType;

  Driver({this.id, @required this.name, @required this.driverRank, @required this.type, @required this.routeID});

  factory Driver.fromJson (Map<String, dynamic> json) => new Driver(
    id        : json["id"],
    name      : json["name"],
    type      : json["type"],
    driverRank: json["driverRank"],
    routeID   : json["routeID"],
  );

  Map<String, dynamic> toJson() => {
    "name"      : this.name,
    "type"      : this.type,
    "driverRank": this.driverRank,
    "routeID"   : this.routeID
  };

  @override
  String toString() => ("Nombre: $name \nTipo: $type \nCalificación: $driverRank \nNúmero de ruta: $routeID \n${route.toString()} \n${transportType.toString()}");
}