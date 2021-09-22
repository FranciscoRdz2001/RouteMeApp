import 'package:flutter/material.dart';
import 'package:music_app/src/RouteMeDBModels/TransportType.dart';
import 'package:music_app/src/custom_widgets/custom_button.dart';
import 'package:music_app/src/custom_widgets/custom_scaffold.dart';
import 'package:music_app/src/custom_widgets/custom_snackBar.dart';
import 'package:music_app/src/custom_widgets/custom_textField.dart';
import 'package:music_app/src/styles/TextStyles.dart';

import '../RouteMeDBModels/Transport.dart';


class AddOrEditTransports extends StatefulWidget {

  Transport transport;
  Function(Transport transport, bool isEditing) onCompleteEvent;
  bool inEditionMode;
  List<TransportType> types;

  AddOrEditTransports({this.transport, @required this.inEditionMode, @required this.onCompleteEvent, @required this.types}){
    if(transport == null) transport = new Transport(capacity: null, typeId: null);
  }

  @override
  _AddOrEditTransportsState createState() => _AddOrEditTransportsState();
}

class _AddOrEditTransportsState extends State<AddOrEditTransports> {
  
  TransportType _selectedType;
  
  @override
  Widget build(BuildContext context) {

    final Size _size = MediaQuery.of(context).size;
    
    return CustomScaffold(
      floatingButtons: [],
      widgets: [
        Text("${widget.inEditionMode ? "Editar" : "Agregar"} un transporte", style: TextStyles.titleApp, textAlign: TextAlign.center),
        SizedBox(height: _size.height * 0.02),
        ClipRRect(child: Image(image: AssetImage("images/transportIcon.png"), height: _size.height * 0.25), borderRadius: BorderRadius.circular(25)),
        SizedBox(height: _size.height * 0.02),
        Text("Ingresa los datos del transporte:", style: TextStyles.buttonText.copyWith(fontSize: 28, color: Colors.black54, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
        SizedBox(height: _size.height * 0.02),
        CustomTextField(function: (value) => widget.transport.capacity = int.tryParse(value), label: "Ingresa la capacidad", controller: TextEditingController(text:  widget.transport.capacity != null ? widget.transport.capacity.toString() : ""), isNumeric: true),
        SizedBox(height: _size.height * 0.02),
        DropdownButton<TransportType>(
          hint: Text("Tipos de transporte disponibles", textAlign: TextAlign.center),
          value: _selectedType,
          onChanged: (TransportType type) {
            setState(() {
              _selectedType = type;
              widget.transport.typeId = type.id;
            });
          },
          items: widget.types.map((type) => DropdownMenuItem<TransportType>(value: type, child: Text("${type.type}", style:  TextStyle(color: Colors.black)))).toList(),
        ),
        SizedBox(height: _size.height * 0.02),
        CustomButton(text: "Aceptar", buttonColor: Colors.green, heigth: _size.height * 0.1, width: _size.width, imageName: "acceptIcon", textIconColor: Colors.green, 
          onTapEvent: () async{
            final bool createdOrEditedSuccessfully = await widget.onCompleteEvent(widget.transport, widget.inEditionMode);
            if(createdOrEditedSuccessfully){
              Navigator.pop(context);
              CustomSnackBar(context: context, message: "Se ha guardado el transporte ${widget.transport.id}.", color: Colors.green);
              Navigator.pop(context);
            }
          }
        )
      ],
    );
  }
}