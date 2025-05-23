import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  bool isDoctor = false;
  String error = "";
  bool isLoading = false;

  Future<void> register() async {
    setState(() {
      error = "";
      isLoading = true;
    });
    final res = await http.post(
      Uri.parse("http://10.0.2.2:8000/register"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "full_name": fullNameCtrl.text,
        "email": emailCtrl.text,
        "password": passwordCtrl.text,
        "is_doctor": isDoctor.toString(),
      },
    );
    setState(() => isLoading = false);
    if (res.statusCode == 200) {
      Navigator.pop(context);
    } else {
      setState(() => error = "Registration failed: ${res.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: fullNameCtrl, decoration: InputDecoration(labelText: "Full Name")),
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordCtrl, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            Row(
              children: [
                Checkbox(value: isDoctor, onChanged: (b) => setState(() => isDoctor = b!)),
                Text("I am a doctor"),
              ],
            ),
            if (error.isNotEmpty) Text(error, style: TextStyle(color: Colors.red)),
            ElevatedButton(onPressed: isLoading ? null : register, child: isLoading ? CircularProgressIndicator() : Text("Register")),
          ],
        ),
      ),
    );
  }
}