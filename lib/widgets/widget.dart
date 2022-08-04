import 'package:flutter/material.dart';

Widget text(text, color, sizes) {
  return Text(text,
      style: TextStyle(
        color: color,
        fontSize: sizes,
      ));
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white));
}

TextStyle simpleTextFieldStyle(colors) {
  return TextStyle(color: colors);
}
