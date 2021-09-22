import 'package:flutter/material.dart';
import 'package:music_app/src/styles/TextStyles.dart';
import 'custom_button.dart';
import 'custom_dataContainer.dart';
import 'custom_scaffoldNoScroll.dart';
import 'custom_snackBar.dart';


class CustomListOfData extends StatelessWidget {

  Function(int id) onDeleteEvent;
  Function(dynamic object) onEditEvent;
  Function() onAddButtonPressedEvent;
  Function() updateDataEvent;
  List data;
  String title;

  CustomListOfData({@required this.data, @required this.onDeleteEvent, @required this.onEditEvent, @required this.title, @required this.updateDataEvent, @required this.onAddButtonPressedEvent});

  @override
  Widget build(BuildContext context){

    final Size _size = MediaQuery.of(context).size;

    Widget getDataInList()
    => data == null ? CircularProgressIndicator() : data.length == 0 ? Text("No hay datos...", style: TextStyles.bodyError.copyWith(color: Colors.red[100], fontWeight: FontWeight.w800),) : 
      Container(
        height: _size.height * 0.60,
        width: _size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white
        ),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: data.length,
          itemBuilder: (_, x){
            return GestureDetector(
              onTap: () async => await onDeleteEvent(x),
              onDoubleTap: () => onEditEvent(data[x]),
              child: CustomDataContainer(dataText: data[x].toString(), height: _size.height, width: _size.width),
            );
          }
        )
      );
  
    return CustomScaffoldNoScroll(
      floatingButtons: [
        CustomButton(text: "Actualizar", buttonColor: Colors.green, heigth: _size.height * 0.10, width: _size.width * 0.25, imageName: "getData", textIconColor: Colors.green, 
        onTapEvent: () async{
          await updateDataEvent();
          CustomSnackBar(color: Colors.green, context: context, message: "Se han actualizado los datos.");
          }
        )
      ],
      widgets: [
        Text(title, style: TextStyles.titleApp, textAlign: TextAlign.center, overflow: TextOverflow.visible),
        SizedBox(height: _size.height * 0.01),
        CustomButton(text: "Agregar", buttonColor: Colors.green, heigth: _size.height * 0.12, width: _size.width, imageName: "addIcon", textIconColor: Colors.green[300], 
        onTapEvent: onAddButtonPressedEvent),
        SizedBox(height: _size.height * 0.025),
        getDataInList()
      ]
    );
  }
}