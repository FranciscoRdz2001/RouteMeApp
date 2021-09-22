import 'dart:math';
import 'package:music_app/src/FormPages/AddOrEditDriver.dart';
import 'package:music_app/src/custom_widgets/custom_alertMessage.dart';
import 'package:music_app/src/custom_widgets/custom_button.dart';
import 'package:music_app/src/custom_widgets/custom_scaffold.dart';
import 'package:music_app/src/custom_widgets/custom_snackBar.dart';
import 'package:music_app/src/pages/ButtonsInHome.dart';
import 'package:music_app/src/styles/TextStyles.dart';

import '../custom_widgets/custom_snackBar.dart';

class HomePage extends StatelessWidget {

  // Colors
  final colors = [
    Colors.yellow,
    Colors.grey,
    Colors.red,
    Colors.blue,
    Colors.lightBlue,
    Colors.purple,
    Colors.orange,
    Colors.pink
  ];
  
  @override
  Widget build(BuildContext context) {

    final Size _size = MediaQuery.of(context).size;
    final RouteDBConnection _routeDB = Provider.of<RouteDBConnection>(context);

    Widget _getDriversData() => _routeDB.drivers == null ? CircularProgressIndicator() : _routeDB.drivers.length == 0 ? Text("No hay choferes en la base de datos", style: TextStyles.bodyFont.copyWith(color: Colors.red[100], fontWeight: FontWeight.w800)) : 
      Container(
        height: _size.height * 0.2,
        width: _size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.black12.withOpacity(0.025)
        ),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: _routeDB.drivers.length,
          itemBuilder: (_, x){
            int randomColor = new Random().nextInt(colors.length);
            return GestureDetector(
              onTap: () async{
                String name = _routeDB.drivers[x].name; 
                CustomAlertMessage(context: context, title: "Eliminar el chofer $name?", message: "¿Estas seguro que deseas eliminarlo?", 
                  onCancel: (){
                    Navigator.pop(context);
                    CustomSnackBar(color: Colors.red, message: "¡No se ha eliminado el chofer $name!", context: context);
                  }, 
                  onAccept: () async{
                    await _routeDB.deleteDriver(_routeDB.drivers[x].id);
                    CustomSnackBar(color: Colors.red, message: "¡Se ha eliminado $name!", context: context);
                    Navigator.pop(context);
                  }
                );
              },
              onDoubleTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddOrEditDriver(inEditionMode: true, driver: _routeDB.drivers[x], onCompleteEvent: (data, isEditing) async => await _routeDB.addOrEditDriver(data, isEditing, context), routes: _routeDB.routes, transportTypes: _routeDB.transportsTypes))),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  height: _size.height * 0.15, width: _size.width * 0.35,
                  decoration: BoxDecoration(
                    color: colors[randomColor].withOpacity(0.15),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(_size.height * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("images/userIcon.png", height: _size.height * 0.05, alignment: Alignment.center),
                          SizedBox(height: _size.height * 0.01),
                          Text(_routeDB.drivers[x].toString(), style: TextStyles.buttonText.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: colors[randomColor].withOpacity(0.5)), textAlign: TextAlign.center, overflow: TextOverflow.visible),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        )
      );

    return CustomScaffold(
      floatingButtons: [
        Padding(
          padding: EdgeInsets.only(left: _size.width * 0.075),
          child: CustomButton(text: "Actualizar", buttonColor: Colors.green, heigth: _size.height * 0.10, width: _size.width, imageName: "updateIcon", textIconColor: Colors.green, 
          onTapEvent: () async{
            await _routeDB.getAllData();
            CustomSnackBar(color: Colors.green, context: context, message: "Se ha actualizado toda la información.");
          }
          ),
        )
      ],
      widgets: [
        Text("Bienvenido a", style: TextStyles.subTitleApp, textAlign: TextAlign.center, overflow: TextOverflow.visible),
        Text("RouteMe", style: TextStyles.titleApp, textAlign: TextAlign.center, overflow: TextOverflow.visible),
        SizedBox(height: _size.height * 0.02),
        ClipRRect(child: Image(image: AssetImage("images/routesLogo.png"), fit: BoxFit.cover, height: _size.height * 0.25, width: _size.width), borderRadius: BorderRadius.circular(100)),
        SizedBox(height: _size.height * 0.01),
        Text("Lista de choferes en nuestra Base de Datos.", style: TextStyles.bodyFont, textAlign: TextAlign.center, overflow: TextOverflow.visible),
        Text("Choferes: ${_routeDB.drivers == null ? 0 : _routeDB.drivers.length} ", style: TextStyles.bodyFont, textAlign: TextAlign.center, overflow: TextOverflow.visible),
        SizedBox(height: _size.height * 0.01),
        _getDriversData(),
        SizedBox(height: _size.height * 0.01),
        CustomButton(text: "Agregar chofer", buttonColor: Colors.green, heigth: _size.height * 0.12, width: _size.width, imageName: "addClientIcon", textIconColor: Colors.green[300], onTapEvent: () {
          if(_routeDB.routes == null || _routeDB.routes.length == 0) CustomSnackBar(color: Colors.red, context: context, message: "¡Primero debes añadir una ruta!");
          else if(_routeDB.transportsTypes == null || _routeDB.transportsTypes.length == 0) CustomSnackBar(color: Colors.red, context: context, message: "¡Primero debes añadir un tipo de transporte!");
          else Navigator.push(context, MaterialPageRoute(builder: (_) => AddOrEditDriver(inEditionMode: false, onCompleteEvent: (data, isEditing) async => await _routeDB.addOrEditDriver(data, isEditing, context), routes: _routeDB.routes, transportTypes: _routeDB.transportsTypes)));
        }),
        SizedBox(height: _size.height * 0.01),
        Text("Selecciona alguna de las siguientes opciones para acceder a las distintas pantallas.", style: TextStyles.bodyFont, textAlign: TextAlign.center, overflow: TextOverflow.visible),
        SizedBox(height: _size.height * 0.02),
        ButtonsInHome()
      ],
    );
  }
}