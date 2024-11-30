import 'package:flutter/material.dart';
import 'pages/home_screen.dart';
import 'pages/landing_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InventoryApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/home': (context) => HomeScreen(), // Replace with your HomePage widget
      },
    );
  }
}
