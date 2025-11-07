import 'package:flutter/material.dart';
import 'screens/pharmacist_page.dart';

void main() {
  runApp(const SmartPharmaApp());
}

class SmartPharmaApp extends StatelessWidget {
  const SmartPharmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Pharma AI',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PharmacistPage(),
    );
  }
}
