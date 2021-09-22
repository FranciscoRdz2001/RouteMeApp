import 'package:flutter/material.dart';
import 'package:music_app/src/connections/RouteDBConnection.dart';
import 'package:music_app/src/pages/HomePage.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RouteDBConnection(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Colors.deepPurple.withOpacity(0.5),
          scaffoldBackgroundColor: Colors.white,
          accentIconTheme: IconThemeData(
            color: Colors.grey[300]
          ),
          iconTheme: IconThemeData(
            size: 35,
            color: Colors.grey[300]
          )
        ),
        title: 'Route-meApp',
        home: HomePage(),
        routes: {
          "homePage": (context) => HomePage(),
        },
      ),
    );
  }
}