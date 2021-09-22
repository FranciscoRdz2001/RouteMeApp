import 'package:flutter/material.dart';
import 'package:music_app/src/RouteMeDBModels/Fare.dart';
import 'package:music_app/src/custom_widgets/custom_button.dart';
import 'package:music_app/src/custom_widgets/custom_scaffold.dart';
import 'package:music_app/src/custom_widgets/custom_snackBar.dart';
import 'package:music_app/src/custom_widgets/custom_textField.dart';
import 'package:music_app/src/styles/TextStyles.dart';

class AddOrEditFare extends StatelessWidget {

  Fare fare;
  Function(Fare fare, bool isEditing) onCompleteEvent;
  bool inEditionMode;

  AddOrEditFare({this.fare, @required this.onCompleteEvent, @required this.inEditionMode}){
    if(!inEditionMode) fare = new Fare(type: "", price: null);
  }

  @override
  Widget build(BuildContext context) {
    
    final Size _size = MediaQuery.of(context).size;

    return CustomScaffold(
      floatingButtons: [],
      widgets: [
        Text("${inEditionMode ? "Editar" : "Agregar"} una tarifa", style: TextStyles.titleApp, textAlign: TextAlign.center),
        SizedBox(height: _size.height * 0.02),
        ClipRRect(child: Image(image: AssetImage("images/fareIcon.png"), height: _size.height * 0.25), borderRadius: BorderRadius.circular(25)),
        Text("Ingresa los datos de la tarifa:", style: TextStyles.buttonText.copyWith(fontSize: 28, color: Colors.black54, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
        SizedBox(height: _size.height * 0.02),
        CustomTextField(function: (value) => fare.type = value, label: "Ingresa el tipo", controller: TextEditingController(text: fare.type?? "")),
        SizedBox(height: _size.height * 0.02),
        CustomTextField(function: (value) => fare.price = double.tryParse(value), label: "Ingresa el precio", controller: TextEditingController(text: fare.price != null ? fare.price.toString() : ""), isNumeric: true),
        SizedBox(height: _size.height * 0.02),
        CustomButton(text: "Aceptar", buttonColor: Colors.green, heigth: _size.height * 0.1, width: _size.width, imageName: "acceptIcon", textIconColor: Colors.green, 
          onTapEvent: () async{
            if(fare.type.contains(new RegExp(r'[0-9]'))) CustomSnackBar(context: context, message: "¡No se puede guardar un nombre con números!", color: Colors.red);
            else{
              final bool createdOrEditedSuccessfully = await onCompleteEvent(fare, inEditionMode);
              if(createdOrEditedSuccessfully){
                Navigator.pop(context);
                CustomSnackBar(context: context, message: "Se ha ${inEditionMode ? "guardado" : "editado"} la tarifa.", color: Colors.green);
                Navigator.pop(context);
              }
            }
          }
        )
      ]
    );
  }
}