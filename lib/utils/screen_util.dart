import 'package:flutter/material.dart';

class ScreenUtils {
  final double width;
  final double height;

  ScreenUtils(BuildContext context)
      : width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
}