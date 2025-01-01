import 'package:flutter/material.dart';
import 'package:weather_app/screens/Loading.dart';
import 'package:weather_app/screens/choose_location.dart';
import 'package:weather_app/screens/home.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
      '/location': (context) => ChooseLocation(),
    },
    debugShowCheckedModeBanner: false,
  ));
}
