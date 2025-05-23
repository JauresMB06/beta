// ... imports, class definition, etc. ...
void sendMessage() async {
  // ... (collect inputs) ...
  setState(() => messages.add({"sender": "user", "text": symptoms}));
  setState(() => _isLoading = true);
  final res = await http.post(
    Uri.parse("http://10.0.2.2:8000/chatbot"),
    headers: {
      "Authorization": "Bearer ${widget.token}",
      "Content-Type": "application/json"
    },
    body: jsonEncode({
      "message": symptoms,
      "age": int.tryParse(age) ?? 30,
      "gender": gender,
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
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("AI Chatbot")),
    body: Column(
      children: [
        // ... input fields as before ...
        if (_isLoading)
          LinearProgressIndicator(),
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