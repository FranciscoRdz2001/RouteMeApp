import 'package:flutter/widgets.dart';

class Schedule{

  int id;
  DateTime time;
  DateTime scheduleDay;
  int routeID;

  Schedule({this.id, @required this.time, @required this.scheduleDay, @required this.routeID});

  factory Schedule.fromJson (Map<String, dynamic> json) => new Schedule(
    id          : json["id"],
    time        : json["time"],
    scheduleDay : json["scheduleDay"],
    routeID     : json["routeID"],
  );

  Map<String, dynamic> toJson() => {
    "time"        : this.time,
    "scheduleDay" : this.scheduleDay,
    "routeID"     : this.routeID,
  };

  @override
  String toString() => ("ID: $id \nTiempo: $time \nDia: $scheduleDay \nID de la ruta: $routeID");
}