import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(CensusApp());
}

class CensusApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Italian Census',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
