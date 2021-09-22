import 'package:flutter/material.dart';
import 'package:music_app/src/styles/TextStyles.dart';


class CustomDataContainer extends StatelessWidget {

  
  String dataText;
  double height;
  double width;

  CustomDataContainer({@required this.dataText, @required this.height, @required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Container(
        height: height * 0.25,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[500].withOpacity(0.15),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Padding(
          padding: EdgeInsets.all(height * 0.001),
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.01),
                  Text("Información:", style: TextStyles.buttonText.copyWith(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
                  SizedBox(height: height * 0.01),
                  Text(dataText, style: TextStyles.buttonText.copyWith(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 20), overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}