import 'package:flutter/material.dart';
import 'package:music_app/src/FormPages/AddOrEditFare.dart';
import 'package:music_app/src/FormPages/AddOrEditRoute.dart';
import 'package:music_app/src/FormPages/AddOrEditStops.dart';
import 'package:music_app/src/FormPages/AddOrEditTransport.dart';
import 'package:music_app/src/FormPages/AddOrEditTransportType.dart';
import 'package:music_app/src/FormPages/AddOrEditUsers.dart';
import 'package:music_app/src/connections/RouteDBConnection.dart';
import 'package:music_app/src/custom_widgets/CustomContainerForData.dart';
import 'package:music_app/src/custom_widgets/custom_alertMessage.dart';
import 'package:music_app/src/custom_widgets/custom_snackBar.dart';
import 'package:music_app/src/custom_widgets/custom_button.dart';
import 'package:provider/provider.dart';

export 'package:provider/provider.dart';
export 'package:flutter/material.dart';
export 'package:music_app/src/FormPages/AddOrEditFare.dart';
export 'package:music_app/src/connections/RouteDBConnection.dart';

class ButtonsInHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final RouteDBConnection _routeDB = Provider.of<RouteDBConnection>(context);
    final Size _size = MediaQuery.of(context).size;
    
    return Container(
      height: _size.height * 0.18,
          width: _size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.black12.withOpacity(0.025)
          ),
          child: ListView(
            padding: EdgeInsets.all(20),
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              CustomButton(buttonColor: Colors.blue, heigth: _size.height * 0.1, imageName: "routesIcon", text: "Rutas: ${_routeDB.routes.length} ", width: _size.width * 0.35, textIconColor: Colors.blue[300],
                onTapEvent: () => Navigator.push(context, MaterialPageRoute(builder: (_) 
                => CustomListOfData( data: _routeDB.routes, title: "Rutas disponibles", updateDataEvent: _routeDB.getRoutes,
                    onDeleteEvent: (index) async{
                      CustomAlertMessage(context: context, title: "Eliminar la ruta ${_routeDB.routes[index].path}", message: "¿Estas seguro que deseas eliminarlo?", 
                        onCancel: (){
                          Navigator.pop(context);
                          CustomSnackBar(color: Colors.red, message: "¡No se ha eliminado la ruta ${_routeDB.routes[index].path}!", context: context);
                        }, 
                        onAccept: () async{
                          Navigator.pop(context);
                          if(await _routeDB.canDeleteRoute(_routeDB.routes[index].id)){
                            String name  = _routeDB.routes[index].path;
                            await _routeDB.deleteRoute(_routeDB.routes[index].id);
                            CustomSnackBar(color: Colors.red, message: "¡Se ha eliminado el la ruta $name!", context: context);
                            Navigator.pop(context);
                          } else CustomSnackBar(color: Colors.red, context: context, message: "¡No se puede eliminar porque esta siendo utilizado!");
                        }
                      );
                    },
                    onAddButtonPressedEvent: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddOrEditRoute(inEditionMode: false, onCompleteEvent: (data, isEditing) async => await _routeDB.addOrEditRoute(data, isEditing, context)))),
                    onEditEvent: (selectedRoute) => Navigator.push(context, MaterialPageRoute(builder: (_) => AddOrEditRoute(route: selectedRoute, inEditionMode: true, onCompleteEvent: (data, isEditing) async => await _routeDB.addOrEditRoute(data, isEditing, context)))),
                  )
                ))
              ),
              SizedBox(width: _size.width * 0.1),
              CustomButton(buttonColor: Colors.blue, heigth: _size.height * 0.1, imageName: "userIcon", text: "Usuarios: ${_routeDB.users.length} ", width: _size.width * 0.35, textIconColor: Colors.blue[300], 
              onTapEvent: () => Navigator.push(context, MaterialPageRoute(builder: (_) 
                => CustomListOfData(data: _routeDB.users, title: "Nuestros usuarios", updateDataEvent: _routeDB.getRoutes,
                    onDeleteEvent: (index) async{
                      CustomAlertMessage(context: context, title: "Eliminar el usuario ${_routeDB.users[index].name}", message: "¿Estas seguro que deseas eliminarlo?", 
                        onCancel: (){
                          Navigator.pop(context);
                          CustomSnackBar(color: Colors.red, message: "¡No se ha eliminado el usuario ${_routeDB.users[index].name}!", context: context);
                        }, 
                        onAccept: () async{
                          String name  = _routeDB.users[index].name;
                          await _routeDB.deleteUser(_routeDB.users[index].id);
                          Navigator.pop(context);
                          CustomSnackBar(color: Colors.red, message: "¡Se ha eliminado el usuario $name!", context: context);
                          Navigator.pop(context);
                        }
                      );
                    },
                    onAddButtonPressedEvent: (){
                      if(_routeDB.fares == null || _routeDB.fares.length == 0) CustomSnackBar(color: Colors.red, context: context, message: "¡Debes agregar un tipo de tarifa primero!");
                      else Navigator.push(context, MaterialPageRoute(builder: (_) => AddOrEditUsers(fares: _routeDB.fares, inEditionMode: false, onCompleteEvent: (data, isEditing) async => await _routeDB.addOrEditUser(data, isEditing, context))));
                    },
                    onEditEvent: (selectedUser){
                      if(_routeDB.fares == null || _routeDB.fares.length == 0) CustomSnackBar(color: Colors.red, context: context, message: "¡Debes agregar un tipo de tarifa primero!");
                      else Navigator.push(context, MaterialPageRoute(builder: (_) => AddOrEditUsers(fares: _routeDB.fares, inEditionMode: true, onCompleteEvent: (data, isEditing) async => await _routeDB.addOrEditUser(data, isEditing, context), user: selectedUser)));
                    })
                ))
              ),
              SizedBox(width: _size.width * 0.1),
              CustomButton(buttonColor: Colors.blue, heigth: _size.height * 0.1, imageName: "fareIcon", text: "Tarifas: ${_routeDB.fares.length} ", width: _size.width * 0.35, textIconColor: Colors.blue[300], 
              onTapEvent: () => Navigator.push(context, MaterialPageRoute(builder: (_) 
                => CustomListOfData(data: _routeDB.fares, title: "Tarifas disponibles", updateDataEvent: _routeDB.getFares,
                    onDeleteEvent: (index) async{
                      CustomAlertMessage(context: context, title: "Eliminar la tarifa ${_routeDB.fares[index].type}", message: "¿Estas seguro que deseas eliminarlo?", 
                        onCancel: (){
                          Navigator.pop(context);
                          CustomSnackBar(color: Colors.red, message: "¡No se ha eliminado la tarifa ${_routeDB.fares[index].type}!", context: context);
                        }, 
                        onAccept: () async{
                          Navigator.pop(context);
                          if(await _routeDB.canDeleteFare(_routeDB.fares[index].id)){
                            String name  = _routeDB.fares[index].type;
                            await _routeDB.deleteFare(_routeDB.fares[index].id);
                            CustomSnackBar(color: Colors.red, message: "¡Se ha eliminado la tarifa $name!", context: context);
                            Navigator.pop(context);
                          } else CustomSnackBar(color: Colors.red, context: context, message: "¡No se puede eliminar porque esta siendo utilizado!");
                        }
                      );
                    },
                    onAddButtonPressedEvent: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddOrEditFare(inEditionMode: false, onCompleteEvent: (data, isEditing) async => await _routeDB.addOrEditFare(data, isEditing, context)))),
                    onEditEvent: (selectedFare) => Navigator.push(context, MaterialPageRoute(builder: (_) => AddOrEditFare(fare: selectedFare, inEditionMode: true, onCompleteEvent: (data, isEditing) async => await _routeDB.addOrEditFare(data, isEditing, context)))),
                  )
                ))
              ),
              SizedBox(width: _size.width * 0.1),
              CustomButton(buttonColor: Colors.blue, heigth: _size.height * 0.1, imageName: "transportIcon", text: "Transportes: ${_routeDB.transports.length} ", width: _size.width * 0.35, textIconColor: Colors.blue[300], 
              onTapEvent: () => Navigator.push(context, MaterialPageRoute(builder: (_) 
                => CustomListOfData(data: _routeDB.transports, title: "Transportes disponibles", updateDataEvent: _routeDB.getTransports,
                    onDeleteEvent: (index) async{
                      CustomAlertMessage(context: context, title: "Eliminar el transporte ${_routeDB.transports[index].id}", message: "¿Estas seguro que deseas eliminarlo?", 
                        onCancel: (){
                          Navigator.pop(context);
                          CustomSnackBar(color: Colors.red, message: "¡No se ha eliminado el transporte ${_routeDB.transports[index].id}!", context: context);
                        }, 
                        onAccept: () async{
                          String name  = _routeDB.transports[index].id.toString();
                          await _routeDB.deleteTransport(_routeDB.transports[index].id);
                          Navigator.pop(context);
                          CustomSnackBar(color: Colors.red, message: "¡Se ha eliminado el transporte $name!", context: context);
                          Navigator.pop(context);
                        }
                      );
                    },
                    onAddButtonPressedEvent: (){
                      if(_routeDB.transportsTypes == null || _routeDB.transportsTypes.length == 0) CustomSnackBar(color: Colors.red, context: context, message: "¡Debes agregar un tipo de transporte primero!");
                      else Navigator.push(context, MaterialPageRoute(builder: (_) => AddOrEditTransports(inEditionMode: false, onCompleteEvent: (data, isEditing) async => await _routeDB.addOrEditTransport(data, isEditing, context), types: _routeDB.transportsTypes)));
                    },
                    onEditEvent: (selectedTransport){
                      if(_routeDB.transportsTypes == null || _routeDB.transportsTypes.length == 0) CustomSnackBar(color: Colors.red, context: context, message: "¡Debes agregar un tipo de transporte primero!");
                      else Navigator.push(context, MaterialPageRoute(builder: (_) => AddOrEditTransports(transport: selectedTransport, inEditionMode: true, onCompleteEvent: (data, isEditing) async => await _routeDB.addOrEditTransport(data, isEditing, context), types: _routeDB.transportsTypes)));
                    },
                  )
                ))
              ),
              SizedBox(width: _size.width * 0.1),
              CustomButton(buttonColor: Colors.blue, heigth: _size.height * 0.1, imageName: "stopIcon", text: "Paradas: ${_routeDB.stops.length}", width: _size.width * 0.35, textIconColor: Colors.blue[300], 
              onTapEvent: () => Navigator.push(context, MaterialPageRoute(builder: (_) 
                => CustomListOfData(data: _routeDB.stops, title: "Paradas disponibles", updateDataEvent: _routeDB.getStops,
                    onDeleteEvent: (index) async{
                      CustomAlertMessage(context: context, title: "Eliminar la parada ${_routeDB.stops[index].name}", message: "¿Estas seguro que deseas eliminarlo?", 
                        onCancel: (){
                          Navigator.pop(context);
                          CustomSnackBar(color: Colors.red, message: "¡No se ha eliminado la parada ${_routeDB.stops[index].name}!", context: context);
                        }, 
                        onAccept: () async{
                          String name  = _routeDB.stops[index].name;
                          await _routeDB.deleteStop(_routeDB.stops[index].id);
                          Navigator.pop(context);
                          CustomSnackBar(color: Colors.red, message: "¡Se ha eliminado la parada $name!", context: context);
                          Navigator.pop(context);
                        }
                      );
                    },
                    onAddButtonPressedEvent: (){
                      if(_routeDB.routes == null || _routeDB.routes.length == 0) CustomSnackBar(color: Colors.red, context: context, message: "¡Debes agregar rutas primero!");
                      else Navigator.push(context, MaterialPageRoute(builder: (_) => AddOrEditStops(inEditionMode: false, onCompleteEvent: (data, isEditing) async => await _routeDB.addOrEditStop(data, isEditing, context), data: _routeDB.routes)));
                    },
                    onEditEvent: (selectedStop){
                      if(_routeDB.routes == null || _routeDB.routes.length == 0) CustomSnackBar(color: Colors.red, context: context, message: "¡Debes agregar rutas primero!");
                      else Navigator.push(context, MaterialPageRoute(builder: (_) => AddOrEditStops(stop: selectedStop, inEditionMode: true, onCompleteEvent: (data, isEditing) async => await _routeDB.addOrEditStop(data, isEditing, context), data: _routeDB.routes)));
                    },
                  )
                ))
              ),
              SizedBox(width: _size.width * 0.1),
              CustomButton(buttonColor: Colors.blue, heigth: _size.height * 0.1, imageName: "transportIcon", text: "Tipos de transporte: ${_routeDB.transportsTypes.length}", width: _size.width * 0.35, textIconColor: Colors.blue[300], 
              onTapEvent: () => Navigator.push(context, MaterialPageRoute(builder: (_) 
                => CustomListOfData(data: _routeDB.transportsTypes, title: "Tipos de Transporte disponibles", updateDataEvent: _routeDB.getTransportTypes,
                    onDeleteEvent: (index) async{
                      CustomAlertMessage(context: context, title: "Eliminar el tipo transporte ${_routeDB.transportsTypes[index].type}", message: "¿Estas seguro que deseas eliminarlo?", 
                        onCancel: (){
                          Navigator.pop(context);
                          CustomSnackBar(color: Colors.red, message: "¡No se ha eliminado el Tipo de Transporte ${_routeDB.transportsTypes[index].type}!", context: context);
                        }, 
                        onAccept: () async{
                          Navigator.pop(context);
                          if(await _routeDB.canDeleteTransportType(_routeDB.transportsTypes[index].id)){
                            String name  = _routeDB.transportsTypes[index].type;
                            await _routeDB.deleteTransportTypes(_routeDB.transportsTypes[index].id);
                            CustomSnackBar(color: Colors.red, message: "¡Se ha eliminado el tipo de transporte $name!", context: context);
                            Navigator.pop(context);
                          } else CustomSnackBar(color: Colors.red, context: context, message: "¡No se puede eliminar porque esta siendo utilizado!");
                        }
                      );
                    },
                    onAddButtonPressedEvent: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddOrEditTransportTypes(inEditionMode: false, onCompleteEvent: (data, isEditing) async => await _routeDB.addOrEditTransportType(data, isEditing, context)))),
                    onEditEvent: (selectedType) => Navigator.push(context, MaterialPageRoute(builder: (_) => AddOrEditTransportTypes(type: selectedType, inEditionMode: true, onCompleteEvent: (data, isEditing) async => await _routeDB.addOrEditTransportType(data, isEditing, context))))
                  )
                ))
              ),
            ],
          ),
    );
  }
}