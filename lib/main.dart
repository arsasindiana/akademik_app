import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() => runApp(const AkademikApp());

class AkademikApp extends StatelessWidget {
  const AkademikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Akademik - Milestone 2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const DashboardScreen(),
    );
  }
}
