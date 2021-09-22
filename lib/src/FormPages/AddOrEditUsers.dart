import 'package:flutter/material.dart';
import 'package:music_app/src/RouteMeDBModels/Usuario.dart';
import 'package:music_app/src/custom_widgets/custom_button.dart';
import 'package:music_app/src/custom_widgets/custom_scaffold.dart';
import 'package:music_app/src/custom_widgets/custom_snackBar.dart';
import 'package:music_app/src/custom_widgets/custom_textField.dart';
import 'package:music_app/src/styles/TextStyles.dart';

import '../RouteMeDBModels/Fare.dart';


class AddOrEditUsers extends StatefulWidget {

  Usuario user;
  Function(Usuario route, bool isEditing) onCompleteEvent;
  bool inEditionMode;
  List<Fare> fares;

  AddOrEditUsers({this.user, @required this.inEditionMode, @required this.onCompleteEvent, @required this.fares}){
    if(user == null) user = new Usuario(email: null, name: null, typeId: null);
  }

  @override
  _AddOrEditUsersState createState() => _AddOrEditUsersState();
}

class _AddOrEditUsersState extends State<AddOrEditUsers> {

  Fare _selectedFare;

  @override
  Widget build(BuildContext context) {

    final Size _size = MediaQuery.of(context).size;
    
    return CustomScaffold(
      floatingButtons: [],
      widgets: [
        Text("${widget.inEditionMode ? "Editar" : "Agregar"} un usuario", style: TextStyles.titleApp, textAlign: TextAlign.center),
        SizedBox(height: _size.height * 0.02),
        ClipRRect(child: Image(image: AssetImage("images/userIcon.png"), height: _size.height * 0.25), borderRadius: BorderRadius.circular(25)),
        SizedBox(height: _size.height * 0.02),
        Text("Ingresa los datos del usuario:", style: TextStyles.buttonText.copyWith(fontSize: 28, color: Colors.black54, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
        SizedBox(height: _size.height * 0.02),
        CustomTextField(function: (value) => widget.user.name = value, label: "Ingresa el nombre", controller: TextEditingController(text: widget.user.name?? "")),
        SizedBox(height: _size.height * 0.02),
        CustomTextField(function: (value) => widget.user.email = value, label: "Ingresa el email", controller: TextEditingController(text: widget.user.email?? "")),
        SizedBox(height: _size.height * 0.02),
        Text("Selecciona la tarifa", style: TextStyles.bodyFont, textAlign: TextAlign.center),
        DropdownButton<Fare>(
          hint: Text("Tarifas disponibles", textAlign: TextAlign.center),
          value: _selectedFare,
          onChanged: (Fare fare) {
            setState(() {
              _selectedFare = fare;
              widget.user.typeId = fare.id;
            });
          },
          items: widget.fares.map((fare) => DropdownMenuItem<Fare>(value: fare, child: Text("${fare.type}", style:  TextStyle(color: Colors.black)))).toList(),
        ),
        CustomButton(text: "Aceptar", buttonColor: Colors.green, heigth: _size.height * 0.1, width: _size.width, imageName: "acceptIcon", textIconColor: Colors.green, 
          onTapEvent: () async{
            if(widget.user.name.contains(new RegExp(r'[0-9]'))) CustomSnackBar(context: context, message: "¡No se puede guardar un nombre con números!", color: Colors.red);
            else{
              final bool createdOrEditedSuccessfully = await widget.onCompleteEvent(widget.user, widget.inEditionMode);
              if(createdOrEditedSuccessfully){
                Navigator.pop(context);
                CustomSnackBar(context: context, message: "Se ha guardado ${widget.user.name}.", color: Colors.green);
                Navigator.pop(context);
              }
            }
          }
        )
      ],
    );
  }
}