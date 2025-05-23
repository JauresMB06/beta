import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'doctor_dashboard.dart';
import 'chatbot_screen.dart';
import 'hospital_locator.dart';
import 'register_screen.dart';
import 'upload_record_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Routing is handled after login/register.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical AI App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        '/login': (_) => LoginScreen(),
        '/register': (_) => RegisterScreen(),
        '/doctor': (_) => DoctorDashboard(),
        '/chatbot': (_) => ChatbotScreen(),
        '/hospital-locator': (_) => HospitalLocator(),
        '/upload-record': (_) => UploadRecordScreen(),
      },
      home: LoginScreen(),
    );
  }
}