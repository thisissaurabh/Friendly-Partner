import 'package:flutter/material.dart';

class DropDownDecoration extends InputDecoration {
  DropDownDecoration({
    bool super.isDense = true,
    super.hintText,
    TextStyle? errorStyle,
    super.fillColor,
    super.hintStyle,
  }) : super(

    errorStyle: errorStyle ??
        const TextStyle(fontSize: 12, color: Colors.red),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        style:BorderStyle.solid,
        width: 0.3,
        color: Colors.black.withOpacity(0.60),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        style: BorderStyle.solid,
        width: 1,
        color: Colors.black.withOpacity(0.60),
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        style:BorderStyle.solid,
        width: 0.3,
        color: Colors.black.withOpacity(0.60),
      ),
    ),

  );
}
