import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slime_farm/navigation.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]);
    return MaterialApp(
      title: 'Slime Farm',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Nav(),
    );
  }
}
