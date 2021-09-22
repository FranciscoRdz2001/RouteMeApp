import 'package:flutter/material.dart';
import 'package:music_app/src/RouteMeDBModels/Driver.dart';
import 'package:music_app/src/RouteMeDBModels/TransportType.dart';
import 'package:music_app/src/custom_widgets/custom_button.dart';
import 'package:music_app/src/custom_widgets/custom_scaffold.dart';
import 'package:music_app/src/custom_widgets/custom_snackBar.dart';
import 'package:music_app/src/custom_widgets/custom_textField.dart';
import 'package:music_app/src/styles/TextStyles.dart';

import '../RouteMeDBModels/Route.dart';


class AddOrEditDriver extends StatefulWidget {

  Driver driver;
  Function(Driver , bool) onCompleteEvent;
  bool inEditionMode;
  List<RouteM> routes;
  List<TransportType> transportTypes;

  AddOrEditDriver({this.driver, @required this.inEditionMode, @required this.onCompleteEvent, @required this.routes, @required this.transportTypes}){
    if(driver == null) driver = new Driver(name: null, driverRank: null, routeID: null, type: null);
  }

  @override
  _AddOrEditDriverState createState() => _AddOrEditDriverState();
}

class _AddOrEditDriverState extends State<AddOrEditDriver> {
  RouteM _selectedRoute;
  TransportType _selectedType;

  @override
  Widget build(BuildContext context) {

    final Size _size = MediaQuery.of(context).size;

    return CustomScaffold(
      floatingButtons: [],
      widgets: [
        Text("${widget.inEditionMode ? "Editar" : "Agregar"} un chofer", style: TextStyles.titleApp, textAlign: TextAlign.center, overflow: TextOverflow.visible),
        SizedBox(height: _size.height * 0.02),
        ClipRRect(child: Image(image: AssetImage("images/userIcon.png"), height: _size.height * 0.25), borderRadius: BorderRadius.circular(25)),
        SizedBox(height: _size.height * 0.02),
        Text("Ingresa los datos del chofer:", style: TextStyles.buttonText.copyWith(fontSize: 28, color: Colors.black54, fontWeight: FontWeight.w700), textAlign: TextAlign.center, overflow: TextOverflow.visible),
        SizedBox(height: _size.height * 0.02),
        CustomTextField(function: (value) => widget.driver.name = value, label: "Ingresa el nombre", controller: TextEditingController(text: widget.driver.name)),
        SizedBox(height: _size.height * 0.02),
        CustomTextField(function: (value) => widget.driver.driverRank = int.tryParse(value), label: "Ingresa el rango", controller: TextEditingController(text: widget.driver.driverRank != null ? widget.driver.driverRank.toString() : ""), isNumeric: true),
        SizedBox(height: _size.height * 0.02),
        Text("Selecciona la ruta", style: TextStyles.bodyFont, textAlign: TextAlign.center),
        DropdownButton<RouteM>(
          hint: Text("Rutas disponibles", textAlign: TextAlign.center),
          value: _selectedRoute,
          onChanged: (RouteM route) {
            setState(() {
              _selectedRoute = route;
              widget.driver.routeID = route.id;
            });
          },
          items: widget.routes.map((route) => DropdownMenuItem<RouteM>(value: route, child: Text("${route.start} - ${route.end}", style:  TextStyle(color: Colors.black)))).toList(),
        ),
        SizedBox(height: _size.height * 0.02),
        Text("Selecciona el tipo de chofer", style: TextStyles.bodyFont, textAlign: TextAlign.center),
        DropdownButton<TransportType>(
          hint: Text("Tipos disponibles", textAlign: TextAlign.center),
          value: _selectedType,
          onChanged: (TransportType type) {
            setState(() {
              _selectedType = type;
              widget.driver.type = type.id;
            });
          },
          items: widget.transportTypes.map((transportType) => DropdownMenuItem<TransportType>(value: transportType, child: Text("${transportType.type}", style:  TextStyle(color: Colors.black)))).toList(),
        ),
        CustomButton(text: "Aceptar", buttonColor: Colors.green, heigth: _size.height * 0.1, width: _size.width, imageName: "acceptIcon", textIconColor: Colors.green, 
          onTapEvent: () async{
            if(widget.driver.name.contains(new RegExp(r'[0-9]'))) CustomSnackBar(context: context, message: "¡No se puede guardar un nombre con números!", color: Colors.red);
            else{
              final bool createdOrEditedSuccessfully = await widget.onCompleteEvent(widget.driver, widget.inEditionMode);
              if(createdOrEditedSuccessfully){
                CustomSnackBar(context: context, message: "Se ha ${widget.inEditionMode ? "guardado" : "editado"} ${widget.driver.name}.", color: Colors.green);
                Navigator.pop(context);
              }
            }
          }
        )
      ],
    );
  }
}
