import 'package:flutter/material.dart';
class CustomSnackBar{
  
  BuildContext context;
  String message;
  MaterialColor color;

  CustomSnackBar({@required this.context, @required this.message, @required this.color}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color[200],
        duration: Duration(milliseconds: 500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        content: Text(message, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}