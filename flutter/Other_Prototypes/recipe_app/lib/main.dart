import 'package:flutter/material.dart';
import 'package:recipe_app/screens/home.dart';
import 'package:recipe_app/screens/add_recipe.dart';
import 'package:recipe_app/screens/show_recipe.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => Home(),
    '/add_recipe': (context) => AddRecipe(),
    '/show_recipe': (context) => ShowRecipe(),
  },
  debugShowCheckedModeBanner: false,
));

