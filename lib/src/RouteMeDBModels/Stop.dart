import 'package:flutter/widgets.dart';

import 'Route.dart';

class Stop{

  int id;
  String name;
  String location;
  String destination;
  int routeID;
  RouteM route;

  Stop({this.id, @required this.name, @required this.location, @required this.destination, @required this.routeID});

  factory Stop.fromJson (Map<String, dynamic> json) => new Stop(
    id          : json["id"],
    name        : json["name"],
    location    : json["location"],
    routeID     : json["routeID"],
    destination : json["destination"],
  );

  Map<String, dynamic> toJson() => {
    "name"        : this.name,
    "location"        : this.location,
    "routeID"     : this.routeID,
    "destination" : this.destination,
  };

  @override
  String toString() => ("ID: $id \nNombre: $name \nLocalización: $location \nID de la ruta: $routeID \nDestino: $destination \n${route.toString()}");
}