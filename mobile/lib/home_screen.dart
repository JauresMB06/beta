import 'package:flutter/material.dart';
import 'medical_records_screen.dart';
import 'chatbot_screen.dart';

class HomeScreen extends StatelessWidget {
  final String token;
  HomeScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Medical Health Home')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.folder),
            title: Text('Medical Records'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => MedicalRecordsScreen(token: token),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('AI Chatbot'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => ChatbotScreen(token: token),
              ));
            },
          ),
        ],
      ),
    );
  }
}