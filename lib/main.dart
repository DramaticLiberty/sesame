
import 'package:flutter/material.dart';
import './screens/home.dart';

void main() => runApp(SesameApp());


class SesameApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Sesam deschide!'),
    );
  }
}
