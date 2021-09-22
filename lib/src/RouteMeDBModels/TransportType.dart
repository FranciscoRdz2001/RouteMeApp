import 'package:flutter/widgets.dart';

class TransportType{

  int id;
  String type;

  TransportType({this.id, @required this.type});

  factory TransportType.fromJson (Map<String, dynamic> json) => new TransportType(
    id          : json["id"],
    type        : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "type"        : this.type,
  };

  @override
  String toString() => ("Tipo: $type");
}