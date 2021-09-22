import 'package:flutter/material.dart';

class CustomScaffoldNoScroll extends StatelessWidget {
  
  List<Widget> widgets; 
  List<Widget> floatingButtons; 

  CustomScaffoldNoScroll({@required this.widgets, @required this.floatingButtons});

  @override
  Widget build(BuildContext context) {

    final Size _size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: floatingButtons,
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: _size.height * 0.065, left: _size.width * 0.05, right: _size.width * 0.05, bottom: _size.height * 0.15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: widgets
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}