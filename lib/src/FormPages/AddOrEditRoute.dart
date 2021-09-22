import 'package:flutter/material.dart';
import 'package:music_app/src/RouteMeDBModels/Route.dart';
import 'package:music_app/src/custom_widgets/custom_button.dart';
import 'package:music_app/src/custom_widgets/custom_scaffold.dart';
import 'package:music_app/src/custom_widgets/custom_snackBar.dart';
import 'package:music_app/src/custom_widgets/custom_textField.dart';
import 'package:music_app/src/styles/TextStyles.dart';


class AddOrEditRoute extends StatelessWidget {

  RouteM route;
  Function(RouteM route, bool isEditing) onCompleteEvent;
  bool inEditionMode;

  AddOrEditRoute({this.route, @required this.inEditionMode, @required this.onCompleteEvent}){
    if(route == null) route = new RouteM(end: null, path: null, start: null);
  }

  @override
  Widget build(BuildContext context) {

    final Size _size = MediaQuery.of(context).size;
    
    return CustomScaffold(
      floatingButtons: [],
      widgets: [
        Text("${inEditionMode ? "Editar" : "Agregar"} una ruta", style: TextStyles.titleApp, textAlign: TextAlign.center),
        SizedBox(height: _size.height * 0.02),
        ClipRRect(child: Image(image: AssetImage("images/routesIcon.png"), height: _size.height * 0.25), borderRadius: BorderRadius.circular(25)),
        SizedBox(height: _size.height * 0.02),
        Text("Ingresa los datos de la ruta:", style: TextStyles.buttonText.copyWith(fontSize: 28, color: Colors.black54, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
        SizedBox(height: _size.height * 0.02),
        CustomTextField(function: (value) => route.start = value, label: "Inicio de la ruta", controller: TextEditingController(text: route.start?? "")),
        SizedBox(height: _size.height * 0.02),
        CustomTextField(function: (value) => route.end = value, label: "Final de la ruta", controller: TextEditingController(text: route.end?? "")),
        SizedBox(height: _size.height * 0.02),
        CustomTextField(function: (value) => route.path = value, label: "Dirección de la ruta", controller: TextEditingController(text: route.path?? "")),
        SizedBox(height: _size.height * 0.02),
        CustomButton(text: "Aceptar", buttonColor: Colors.green, heigth: _size.height * 0.1, width: _size.width, imageName: "acceptIcon", textIconColor: Colors.green, 
          onTapEvent: () async{
            final bool createdOrEditedSuccessfully = await onCompleteEvent(route, inEditionMode);
            if(createdOrEditedSuccessfully){
              Navigator.pop(context);
              CustomSnackBar(context: context, message: "Se ha guardado ${route.path}.", color: Colors.green);
              Navigator.pop(context);
            }
          }
        )
      ],
    );
  }
}