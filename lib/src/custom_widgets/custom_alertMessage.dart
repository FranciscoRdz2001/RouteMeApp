import 'package:flutter/material.dart';
import 'package:music_app/src/styles/TextStyles.dart';


class CustomAlertMessage{

  
  BuildContext context;
  String title;
  String message;
  Function() onAccept;
  Function() onCancel;

  CustomAlertMessage({@required this.context, @required this.title, @required this.message, @required this.onCancel, @required this.onAccept}){

    showDialog<void>(
    context: context,
    barrierDismissible: true, 
    builder: (BuildContext context) =>
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text(title, style: TextStyles.titleApp.copyWith(fontSize: 25), textAlign: TextAlign.center,),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("$message.", style: TextStyles.buttonText, textAlign: TextAlign.center,)
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: onCancel
          ),
          TextButton(
            child: Text('Aceptar'),
            onPressed: onAccept
          ),
        ],
      )
    );
  }
}