import 'package:flutter/widgets.dart';

class RouteM{

  int id;
  String path;
  String end;
  String start;

  RouteM({this.id, @required this.path, @required this.end, @required this.start});

  factory RouteM.fromJson (Map<String, dynamic> json) => new RouteM(
    id       : json["id"],
    path     : json["path"],
    end      : json["end"],
    start    : json["start"],
  );

  Map<String, dynamic> toJson() => {
    "path"  : this.path,
    "end"   : this.end,
    "start" : this.start,
  };

  @override
  String toString() => ("Dirección: $path \nInicio: $start \nFin: $end");
}