import 'package:flutter/material.dart';
import 'package:sos_ospedale/screens/homepage.dart';

void main() {
  runApp(const SosOspedaleApp());
}

class SosOspedaleApp extends StatelessWidget {
  const SosOspedaleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOS Ospedale',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.red,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

