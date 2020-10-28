import 'package:flutter/material.dart';
import 'package:matching_game/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
          buttonBarTheme: ButtonBarThemeData(
        alignment: MainAxisAlignment.spaceEvenly,
      )),
    );
  }
}
