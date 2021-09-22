import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/RouteMeDBModels/Driver.dart';
import 'package:sqflite/sqflite.dart';

import '../RouteMeDBModels/Route.dart';
import '../custom_widgets/custom_snackBar.dart';
import '../RouteMeDBModels/Fare.dart';
import '../RouteMeDBModels/Schedule.dart';
import '../RouteMeDBModels/Stop.dart';
import '../RouteMeDBModels/Transport.dart';
import '../RouteMeDBModels/TransportType.dart';
import '../RouteMeDBModels/Usuario.dart';
import '../RouteMeDBModels/Driver.dart';


class RouteDBConnection with ChangeNotifier{

  Database _database;

  // Data
  List<Driver> drivers;
  List<Usuario> users;
  List<RouteM> routes;
  List<Transport> transports;
  List<Fare> fares;
  List<Schedule> schedules;
  List<Stop> stops;
  List<TransportType> transportsTypes;

  RouteDBConnection(){
    _startAll();
  }

  void _startAll() async{


    drivers = [];
    users = [];
    routes = [];
    transports = [];
    fares = [];
    schedules = [];
    stops = [];
    transportsTypes = [];

    await _initDB();
    await getAllData();
  }

  Future<void> _initDB() async{
    _database = await openDatabase(
      "4a.db",
      onCreate: (db, version) async{
        await db.execute("""
        CREATE TABLE USUARIO(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
          name VARCHAR(25) NOT NULL, 
          email VARCHAR(25) NOT NULL, 
          typeId INTEGER NOT NULL)
        """);
        await db.execute("""
        CREATE TABLE ROUTE(
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
          start VARCHAR(25) NOT NULL, 
          path VARCHAR(25) NOT NULL, 
          end VARCHAR(25) NOT NULL)
          """);
        await db.execute("""
        CREATE TABLE DRIVER(
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
          name VARCHAR(25) NOT NULL, 
          type INTEGER NOT NULL, 
          driverRank INTEGER NOT NULL, 
          routeID INTEGER NOT NULL, 
          FOREIGN KEY (routeID) REFERENCES ROUTE(id))
        """);
        await db.execute("""
        CREATE TABLE TRANSPORT(
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
          capacity INTEGER NOT NULL, 
          typeId INTEGER NOT NULL, 
          FOREIGN KEY (typeId) REFERENCES TRANSPORT_TYPE(id))
        """);
        await db.execute("""
        CREATE TABLE FARE(
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
          type VARCHAR(25) NOT NULL, 
          price FLOAT NOT NULL)
        """);
        await db.execute("""
        CREATE TABLE SCHEDULE(
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          time DATE NOT NULL, 
          scheduleDay DATE NOT NULL, 
          routeID INTEGER NOT NULL, 
          FOREIGN KEY(routeID) REFERENCES ROUTE(id))
        """);
        await db.execute("""
        CREATE TABLE STOP(
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          name VARCHAR(25) NOT NULL, 
          location VARCHAR(25) NOT NULL, 
          destination VARCHAR(25) NOT NULL, 
          routeID INTEGER NOT NULL, 
          FOREIGN KEY(routeID) REFERENCES ROUTE(id))
        """);
        await db.execute("""
        CREATE TABLE TRANSPORT_TYPE(
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          type VARCHAR(25) NOT NULL)
        """);
        await db.execute("""
        CREATE TABLE USER_DESTINATION(
          userID INTEGER NOT NULL, 
          routeID INTEGER NOT NULL, 
          FOREIGN KEY(userID) REFERENCES USUARIO (id), 
          FOREIGN KEY(routeID) REFERENCES ROUTE (id))
        """);
        await db.execute("""
        CREATE TABLE USER_DRIVER_RANK(
          stars INTEGER NOT NULL,
          userID INTEGER NOT NULL,
          driverID INTEGER NOT NULL,
          FOREIGN KEY(userID) REFERENCES USUARIO (id) FOREIGN KEY(driverID) REFERENCES DRIVER(id))
        """);
      },
      version: 1,
    );
  }

  // GET DATA
  Future<void> getAllData() async{
    await getDrivers();
    await getUsers();
    await getFares();
    await getRoutes();
    await getStops();
    await getTransports();
    await getTransportTypes();
  }

  Future<void> getDrivers() async{
    final response = await _getTable("DRIVER");
    drivers = List.generate(response.length, (x) => Driver.fromJson(response[x]));
    for(int x = 0; x < drivers.length; x++) drivers[x].route = RouteM.fromJson((await getElementFromTable("ROUTE", drivers[x].routeID))[0]);
    for(int x = 0; x < drivers.length; x++) drivers[x].transportType = TransportType.fromJson((await getElementFromTable("TRANSPORT_TYPE", drivers[x].type))[0]);
    notifyListeners();
  }

  Future<void> getUsers() async{
    final response = await _getTable("USUARIO");
    users = List.generate(response.length, (x) => Usuario.fromJson(response[x]));
    for(int x = 0; x < users.length; x++) users[x].type = Fare.fromJson((await getElementFromTable("FARE", users[x].typeId))[0]);
    notifyListeners();
  }

  Future<void> getFares() async{
    final response = await _getTable("FARE");
    fares = List.generate(response.length, (x) => Fare.fromJson(response[x]));
    notifyListeners();
  }

  Future<void> getRoutes() async{
    final response = await _getTable("ROUTE");
    routes = List.generate(response.length, (x) => RouteM.fromJson(response[x]));
    notifyListeners();
  }

  Future<void> getStops() async{
    final response = await _getTable("STOP");
    stops = List.generate(response.length, (x) => Stop.fromJson(response[x]));
    for(int x = 0; x < stops.length; x++) stops[x].route = RouteM.fromJson((await getElementFromTable("ROUTE", stops[x].routeID))[0]);
    notifyListeners();
  }

  Future<void> getTransports() async{
    final response = await _getTable("TRANSPORT");
    transports = List.generate(response.length, (x) => Transport.fromJson(response[x]));
    for(int x = 0; x < transports.length; x++) transports[x].type = TransportType.fromJson((await getElementFromTable("TRANSPORT_TYPE", transports[x].typeId))[0]);
    notifyListeners();
  }

  Future<void> getTransportTypes() async{
    final response = await _getTable("TRANSPORT_TYPE");
    transportsTypes = List.generate(response.length, (x) => TransportType.fromJson(response[x]));
    notifyListeners();
  }

  // ADD DATA
  Future<bool> addOrEditUser(Usuario u, bool isEditing, BuildContext context) async{
    bool isValid = _isCorrect(u.toJson(), context);
    if(!isValid) return false;
    isEditing ? _editInTable("USUARIO", u.toJson(), u.id) :  await _addToTable("USUARIO", u.toJson());
    await getUsers();
    return true;
  }

  Future<bool> addOrEditDriver(Driver d, bool isEditing, BuildContext context) async{
    bool isValid = _isCorrect(d.toJson(), context);
    if(!isValid) return false;
    isEditing ? _editInTable("DRIVER", d.toJson(), d.id) :  await _addToTable("DRIVER", d.toJson());
    await getDrivers();
    return true;
  }

  Future<bool> addOrEditFare(Fare f, bool isEditing, BuildContext context) async{
    bool isValid = _isCorrect(f.toJson(), context);
    if(!isValid) return false;
    await (isEditing ? _editInTable("FARE", f.toJson(), f.id) : _addToTable("FARE", f.toJson()));
    await getFares();
    return true;
  }

  Future<bool> addOrEditRoute(RouteM r, bool isEditing, BuildContext context) async{
    bool isValid = _isCorrect(r.toJson(), context);
    if(!isValid) return false;
    isEditing ? _editInTable("ROUTE", r.toJson(), r.id) :  await _addToTable("ROUTE", r.toJson());
    await getRoutes();
    return true;
  }

  Future<bool> addOrEditStop(Stop s, bool isEditing, BuildContext context) async{
    bool isValid = _isCorrect(s.toJson(), context);
    if(!isValid) return false;
    isEditing ? _editInTable("STOP", s.toJson(), s.id) :  await _addToTable("STOP", s.toJson());
    await getStops();
    return true;
  }

  Future<bool> addOrEditTransport(Transport t, bool isEditing, BuildContext context) async{
    bool isValid = _isCorrect(t.toJson(), context);
    if(!isValid) return false;
    isEditing ? _editInTable("TRANSPORT", t.toJson(), t.id) :  await _addToTable("TRANSPORT", t.toJson());
    await getTransports();
    return true;
  }

  Future<bool> addOrEditTransportType(TransportType t, bool isEditing, BuildContext context) async{
    bool isValid = _isCorrect(t.toJson(), context);
    if(!isValid) return false;
    isEditing ? _editInTable("TRANSPORT_TYPE", t.toJson(), t.id) :  await _addToTable("TRANSPORT_TYPE", t.toJson());
    await getTransportTypes();
    return true;
  }

  // DELETE DATA
  Future<void> deleteDriver(int id) async{
    await _removeFromTable(id, "DRIVER");
    await getDrivers();
  }

  Future<void> deleteRoute(int id) async{
    await _removeFromTable(id, "ROUTE");
    await getRoutes();
  }

  Future<void> deleteUser(int id) async{
    await _removeFromTable(id, "USUARIO");
    await getUsers();
  }

  Future<void> deleteTransport(int id) async{
    await _removeFromTable(id, "TRANSPORT");
    await getTransports();
  }

  Future<void> deleteFare(int id) async{
    await _removeFromTable(id, "FARE");
    await getFares();
  }

  Future<void> deleteStop(int id) async{
    print(id);
    await _removeFromTable(id, "STOP");
    await getStops();
  }

  Future<void> deleteTransportTypes(int id) async{
    await _removeFromTable(id, "TRANSPORT_TYPE");
    await getTransportTypes();
  }

  // VALIDACIONES
  bool _isCorrect(Map<String, dynamic> data, BuildContext context){
    print(data);
    for(int x = 0; x < data.length; x++){
      if(data.values.elementAt(x) == null || data.values.elementAt(x).toString() == ""){
        CustomSnackBar(color: Colors.red, context: context, message: "Debes llenar todos los datos");
        return false;
      }
      else if(data.values.elementAt(x).toString().length > 25){
        CustomSnackBar(color: Colors.red, context: context, message: "El tamaño del texto es muy grande");
        return false;
      }
    }
    return true;
  }
  Future<List<Map<String, dynamic>>> _getTable(String table) async => await _database.rawQuery("SELECT * FROM $table");
  Future<int> _addToTable(String table, Map<String, dynamic> toInsert) async => await _database.insert(table, toInsert, conflictAlgorithm: ConflictAlgorithm.abort);
  Future<void> _removeFromTable(int id, String table) async => await _database.rawDelete("DELETE FROM $table WHERE id = $id");
  Future<int> _editInTable(String table, Map<String, dynamic> toInsert, int id) async => await _database.update(table, toInsert, where: 'id = ?', whereArgs: [id]);
  Future<List<Map<String, dynamic>>> getElementFromTable(String table, int id) async => await _database.rawQuery("SELECT * FROM $table WHERE id = $id");
  Future<bool> canDeleteRoute(int routeID) async{
    final driversList = await _database.rawQuery("SELECT * FROM DRIVER WHERE routeID = $routeID");
    final stopsList = await _database.rawQuery("SELECT * FROM STOP WHERE routeID = $routeID");
    return driversList.length != 0 || stopsList.length != 0 ? false : true;
  }
  Future<bool> canDeleteTransportType(int transportTypeID) async{
    final transportList = await _database.rawQuery("SELECT * FROM TRANSPORT WHERE typeId = $transportTypeID");
    final driversList = await _database.rawQuery("SELECT * FROM DRIVER WHERE type = $transportTypeID");
    return driversList.length != 0 || transportList.length != 0 ? false : true;
  }
  Future<bool> canDeleteFare(int fareID) async => (await _database.rawQuery("SELECT * FROM USUARIO WHERE typeId = $fareID")).length == 0;
  bool nameIsInvalid(String value) => value.contains(new RegExp(r'[0-9]'));
}