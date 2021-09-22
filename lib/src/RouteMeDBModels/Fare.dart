


import 'package:flutter/widgets.dart';

class Fare{

  int id;
  String type;
  double price;

  Fare({this.id, @required this.type, @required this.price});

  factory Fare.fromJson (Map<String, dynamic> json) => new Fare(
    id          : json["id"],
    type        : json["type"],
    price       : json["price"],
  );

  Map<String, dynamic> toJson() => {
    "type"        : this.type,
    "price"        : this.price,
  };

  @override
  String toString() => ("Tipo: $type \nprice: $price");
}