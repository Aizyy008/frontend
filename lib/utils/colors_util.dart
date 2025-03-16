import 'package:flutter/material.dart';

class ColorConverter {

  static Color white = Colors.white;
  static Color blue = Colors.blue;
  static Color black = Colors.black;

  static Color fromHex(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }
}