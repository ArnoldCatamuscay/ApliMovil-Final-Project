import 'package:flutter/material.dart';

const Color primary = Color(0xff6639b6); //0xff272838
const Color blanco = Color(0xffF9F8F8);

ThemeData myTheme(BuildContext con) {
  return ThemeData(
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: primary, //? Color de fondo del AppBar
      foregroundColor: blanco, //? Color de las letras del AppBar
    ),

    // colorScheme: ColorScheme.fromSwatch(
    //   primarySwatch: Colors.indigo,
    // ).copyWith(
    //   secondary: Colors.purple,
    // )
  );
}
