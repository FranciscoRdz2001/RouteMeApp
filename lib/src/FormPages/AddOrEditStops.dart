import 'package:flutter/material.dart';
import 'package:music_app/src/custom_widgets/custom_button.dart';
import 'package:music_app/src/custom_widgets/custom_scaffold.dart';
import 'package:music_app/src/custom_widgets/custom_snackBar.dart';
import 'package:music_app/src/custom_widgets/custom_textField.dart';
import 'package:music_app/src/styles/TextStyles.dart';

import '../RouteMeDBModels/Route.dart';
import '../RouteMeDBModels/Stop.dart';


class AddOrEditStops extends StatefulWidget {

  Stop stop;
  Function(Stop stop, bool isEditing) onCompleteEvent;
  bool inEditionMode;
  List<RouteM> data;

  AddOrEditStops({this.stop, @required this.inEditionMode, @required this.onCompleteEvent, @required this.data}){
    if(stop == null) stop = new Stop(destination: '', name: '', routeID: null, location: '');
  }

  @override
  _AddOrEditStopsState createState() => _AddOrEditStopsState();
}

class _AddOrEditStopsState extends State<AddOrEditStops> {
  RouteM selectedRoute;

  @override
  Widget build(BuildContext context) {

    final Size _size = MediaQuery.of(context).size;
    
    return CustomScaffold(
      floatingButtons: [],
      widgets: [
        Text("${widget.inEditionMode ? "Editar" : "Agregar"} una parada", style: TextStyles.titleApp, textAlign: TextAlign.center),
        SizedBox(height: _size.height * 0.02),
        ClipRRect(child: Image(image: AssetImage("images/stopIcon.png"), height: _size.height * 0.25), borderRadius: BorderRadius.circular(25)),
        SizedBox(height: _size.height * 0.02),
        Text("Ingresa los datos de la parada:", style: TextStyles.buttonText.copyWith(fontSize: 28, color: Colors.black54, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
        SizedBox(height: _size.height * 0.02),
        CustomTextField(function: (value) => widget.stop.name = value, label: "Nombre de la parada", controller: TextEditingController(text: widget.stop.name?? "")),
        SizedBox(height: _size.height * 0.02),
        CustomTextField(function: (value) => widget.stop.location = value, label: "Localización de la parada ", controller: TextEditingController(text: widget.stop.location?? "")),
        SizedBox(height: _size.height * 0.02),
        CustomTextField(function: (value) => widget.stop.destination = value, label: "Destino de la parada", controller: TextEditingController(text: widget.stop.destination?? "")),
        SizedBox(height: _size.height * 0.02),
        Text("Selecciona la ruta", style: TextStyles.bodyFont, textAlign: TextAlign.center),
        DropdownButton<RouteM>(
          hint: Text("Rutas disponibles", textAlign: TextAlign.center),
          value: selectedRoute,
          onChanged: (RouteM route) {
            setState(() {
              selectedRoute = route;
              widget.stop.routeID = route.id;
            });
          },
          items: widget.data.map((route) => DropdownMenuItem<RouteM>(value: route, child: Text("${route.start} - ${route.end}", style:  TextStyle(color: Colors.black)))).toList(),
        ),
        SizedBox(height: _size.height * 0.02),
        CustomButton(text: "Aceptar", buttonColor: Colors.green, heigth: _size.height * 0.1, width: _size.width, imageName: "acceptIcon", textIconColor: Colors.green, 
          onTapEvent: () async{
            final bool createdOrEditedSuccessfully = await widget.onCompleteEvent(widget.stop, widget.inEditionMode);
            if(createdOrEditedSuccessfully){
              Navigator.pop(context);
              CustomSnackBar(context: context, message: "Se ha guardado ${widget.stop.name}.", color: Colors.green);
              Navigator.pop(context);
            }
          }
        )
      ],
    );
  }
}