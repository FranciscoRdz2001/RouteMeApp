import 'package:flutter/widgets.dart';

import 'Fare.dart';

class Usuario{

  int id;
  String name;
  String email;
  int typeId;
  Fare type;

  Usuario({this.id, @required this.name, @required this.email, @required this.typeId});

  factory Usuario.fromJson (Map<String, dynamic> json) => new Usuario(
    id       : json["id"],
    name     : json["name"],
    email    : json["email"],
    typeId   : json["typeId"],
  );

  Map<String, dynamic> toJson() => {
    "name"      : this.name,
    "email"     : this.email,
    "typeId"    : this.typeId,
  };

  @override
  String toString() => ("ID: $id \nNombre: $name \nTipo: $typeId \nEmail: $email \n${type.toString()}");
}