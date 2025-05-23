import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotScreen extends StatefulWidget {
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _symptomsCtrl = TextEditingController();
  final TextEditingController _ageCtrl = TextEditingController();
  final TextEditingController _historyCtrl = TextEditingController();
  String _gender = "other";
  bool _isLoading = false;
  List<Map<String, String>> messages = [];
  String? token;

  @override
  void didChangeDependencies() {
    token = ModalRoute.of(context)?.settings.arguments as String?;
    super.didChangeDependencies();
  }

  void sendMessage() async {
    final symptoms = _symptomsCtrl.text.trim();
    final age = _ageCtrl.text.trim();
    final history = _historyCtrl.text.trim();

    if (symptoms.isEmpty || token == null) return;

    setState(() => messages.add({"sender": "user", "text": symptoms}));
    setState(() => _isLoading = true);
    final res = await http.post(
      Uri.parse("http://10.0.2.2:8000/chatbot"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "message": symptoms,
        "age": int.tryParse(age) ?? 30,
        "gender": _gender,
        "history": history
      }),
    );
    setState(() => _isLoading = false);
    if (res.statusCode == 200) {
      final reply = jsonDecode(res.body)['response'];
      setState(() => messages.add({
        "sender": "bot",
        "text": reply,
      }));
    } else {
      setState(() => messages.add({
        "sender": "bot",
        "text": "Sorry, there was an error. Please try again."
      }));
    }
    _symptomsCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Chatbot")),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text("Menu")),
            ListTile(
              title: Text("Hospital Locator"),
              onTap: () => Navigator.pushNamed(context, '/hospital-locator'),
            ),
            ListTile(
              title: Text("Upload Medical Record"),
              onTap: () => Navigator.pushNamed(context, '/upload-record', arguments: token),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: _symptomsCtrl,
                  decoration: InputDecoration(labelText: "Symptoms (comma separated)"),
                ),
                TextField(
                  controller: _ageCtrl,
                  decoration: InputDecoration(labelText: "Age"),
                  keyboardType: TextInputType.number,
                ),
                DropdownButton<String>(
                  value: _gender,
                  items: [
                    DropdownMenuItem(value: "male", child: Text("Male")),
                    DropdownMenuItem(value: "female", child: Text("Female")),
                    DropdownMenuItem(value: "other", child: Text("Other")),
                  ],
                  onChanged: (v) => setState(() => _gender = v ?? "other"),
                ),
                TextField(
                  controller: _historyCtrl,
                  decoration: InputDecoration(labelText: "Medical History (comma separated)"),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: sendMessage,
                  child: Text("Send"),
                ),
              ],
            ),
          ),
          if (_isLoading) LinearProgressIndicator(),
          Divider(),
          Expanded(
              child: ListView(
                children: messages
                    .map((m) => Card(
                          color: m["sender"] == "user"
                              ? Colors.blue[50]
                              : Colors.green[50],
                          child: ListTile(
                            title: Text(m["text"] ?? ""),
                            subtitle: Text(m["sender"] == "user" ? "You" : "Bot"),
                          ),
                        ))
                    .toList(),
              )),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Disclaimer: This app does not replace professional medical advice. Always consult a doctor.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}