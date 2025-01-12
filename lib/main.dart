import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(CensusApp());
}

class CensusApp extends StatelessWidget {
  const CensusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Italian Census',
      theme: ThemeData(
     colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green),
        primarySwatch: Colors.green,primaryColor: Colors.red),
      home: HomeScreen(),
    );
  }
}
