import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'services/attendance_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AttendanceService()),
      ],
      child: const AMGPrototipeApp(),
    ),
  );
}

class AMGPrototipeApp extends StatelessWidget {
  const AMGPrototipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AMG Prototipe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF2563EB),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const LoginScreen(),
    );
  }
}
