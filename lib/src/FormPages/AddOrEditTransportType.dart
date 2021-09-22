import 'package:flutter/material.dart';
import 'package:music_app/src/RouteMeDBModels/TransportType.dart';
import 'package:music_app/src/custom_widgets/custom_button.dart';
import 'package:music_app/src/custom_widgets/custom_scaffold.dart';
import 'package:music_app/src/custom_widgets/custom_snackBar.dart';
import 'package:music_app/src/custom_widgets/custom_textField.dart';
import 'package:music_app/src/styles/TextStyles.dart';


class AddOrEditTransportTypes extends StatelessWidget {

  Function(TransportType type, bool isEditing) onCompleteEvent;
  TransportType type;
  bool inEditionMode;

  AddOrEditTransportTypes({this.type, @required this.inEditionMode, @required this.onCompleteEvent}){
    if(type == null) type = new TransportType(type: '');
  }

  @override
  Widget build(BuildContext context) {

    final Size _size = MediaQuery.of(context).size;
    
    return CustomScaffold(
      floatingButtons: [],
      widgets: [
        Text("${inEditionMode ? "Editar" : "Agregar"} un tipo de transporte", style: TextStyles.titleApp, textAlign: TextAlign.center),
        SizedBox(height: _size.height * 0.02),
        ClipRRect(child: Image(image: AssetImage("images/transportIcon.png"), height: _size.height * 0.25), borderRadius: BorderRadius.circular(25)),
        SizedBox(height: _size.height * 0.02),
        Text("Ingresa los datos del tipo de transporte:", style: TextStyles.buttonText.copyWith(fontSize: 28, color: Colors.black54, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
        SizedBox(height: _size.height * 0.02),
        CustomTextField(function: (value) => type.type = value, label: "Ingresa el tipo", controller: TextEditingController(text: type.type?? "")),
        SizedBox(height: _size.height * 0.02),
        CustomButton(text: "Aceptar", buttonColor: Colors.green, heigth: _size.height * 0.1, width: _size.width, imageName: "acceptIcon", textIconColor: Colors.green, 
          onTapEvent: () async{
            if(type.type.contains(new RegExp(r'[0-9]'))) CustomSnackBar(context: context, message: "¡No se puede guardar un nombre con números!", color: Colors.red);
            else{
              final bool createdOrEditedSuccessfully = await onCompleteEvent(type, inEditionMode);
              if(createdOrEditedSuccessfully){
                Navigator.pop(context);
                CustomSnackBar(context: context, message: "Se ha guardado el transporte ${type.id}.", color: Colors.green);
                Navigator.pop(context);
              }
            }
          }
        )
      ],
    );
  }
}