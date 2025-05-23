import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  bool isLoading = false;
  String error = "";

  Future<void> login() async {
    setState(() {
      isLoading = true;
      error = "";
    });
    final res = await http.post(
      Uri.parse("http://10.0.2.2:8000/token"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "username": emailCtrl.text,
        "password": passwordCtrl.text,
      },
    );
    setState(() => isLoading = false);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final token = data["access_token"];
      // For demo: doctors use doctor@clinic.com, patients use others
      if (emailCtrl.text.contains("doctor")) {
        Navigator.pushReplacementNamed(context, '/doctor', arguments: token);
      } else {
        Navigator.pushReplacementNamed(context, '/chatbot', arguments: token);
      }
    } else {
      setState(() => error = "Invalid credentials");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordCtrl, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 12),
            if (error.isNotEmpty) Text(error, style: TextStyle(color: Colors.red)),
            ElevatedButton(onPressed: isLoading ? null : login, child: isLoading ? CircularProgressIndicator() : Text("Login")),
            TextButton(
              child: Text("Don't have an account? Register"),
              onPressed: () => Navigator.pushNamed(context, '/register'),
            ),
          ],
        ),
      ),
    );
  }
}