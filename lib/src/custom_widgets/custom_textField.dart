import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {

  Function(String value) function;
  String label;
  TextEditingController controller;
  bool isNumeric = null;

  CustomTextField({@required this.function, @required this.label, this.isNumeric, this.controller});
  
  @override
  Widget build(BuildContext context) {
    return TextFormField (
      keyboardType: isNumeric != null ? TextInputType.numberWithOptions(decimal: false, signed: false) : TextInputType.text,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'.')), FilteringTextInputFormatter.deny(' ')],
      controller: controller,
      onChanged: (value){
        print(value);
        function(value);
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        labelText: label,
      ),
    );
  }
}