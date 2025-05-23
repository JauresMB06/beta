import 'package:flutter/material.dart';
import 'chatbot_screen.dart';
import 'doctor_dashboard.dart';
import 'hospital_locator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Assume you have authentication flow to set token and userType ("doctor" or "patient")
  final String token = "YOUR_JWT_TOKEN";
  final String userType = "doctor"; // or "patient"

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical AI App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: userType == "doctor"
          ? DoctorDashboard(token: token)
          : ChatbotScreen(token: token),
      routes: {
        '/hospital-locator': (_) => HospitalLocator(),
      },
    );
  }
}