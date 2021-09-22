import 'package:flutter/material.dart';
import 'package:music_app/src/styles/TextStyles.dart';

class CustomButton extends StatelessWidget {

  
  Function() onTapEvent;
  MaterialColor buttonColor;
  Color textIconColor;
  String imageName;
  String text;
  double heigth;
  double width;

  CustomButton({@required this.text, @required this.buttonColor, @required this.heigth, @required this.width, @required this.imageName, @required this.textIconColor, @required this.onTapEvent});
  
  @override
  Widget build(BuildContext context) 
    => GestureDetector(
      onTap: onTapEvent,
      child: Container(
        height: heigth,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor[100].withOpacity(0.90),
          borderRadius: BorderRadius.all(Radius.circular(25))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/$imageName.png", alignment: Alignment.center, height: MediaQuery.of(context).size.height * 0.035,),
            Text(text, style: TextStyles.buttonText.copyWith(color: textIconColor), textAlign: TextAlign.center, overflow: TextOverflow.visible),
          ],
        ),
      ),
    );
  }