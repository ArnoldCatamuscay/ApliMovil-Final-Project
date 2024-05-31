import 'package:flutter/material.dart';

const Color primary = Color(0xff272838);
const Color blanco = Color(0xffF9F8F8);

myTheme(BuildContext con){
  return ThemeData(
    primaryColor: primary,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.yellow,
    ).copyWith(
      secondary: Colors.amber,
    )
  );
}