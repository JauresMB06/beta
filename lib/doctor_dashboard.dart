import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorDashboard extends StatefulWidget {
  final String token;
  DoctorDashboard({required this.token});
  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  List patients = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  void fetchPatients() async {
    setState(() => loading = true);
    final res = await http.get(
      Uri.parse("http://10.0.2.2:8000/patients"),
      headers: {"Authorization": "Bearer ${widget.token}"},
    );
    if (res.statusCode == 200) {
      setState(() {
        patients = jsonDecode(res.body);
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  void openPatientDetail(int id, String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PatientDetailScreen(token: widget.token, patientId: id, patientName: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Doctor Dashboard")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: patients
                  .map((p) => ListTile(
                        title: Text(p['name']),
                        subtitle: Text(p['email']),
                        onTap: () => openPatientDetail(p['id'], p['name']),
                      ))
                  .toList(),
            ),
    );
  }
}

class PatientDetailScreen extends StatefulWidget {
  final String token;
  final int patientId;
  final String patientName;
  PatientDetailScreen(
      {required this.token, required this.patientId, required this.patientName});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  List records = [];
  List chatlogs = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  void fetchDetail() async {
    setState(() => loading = true);
    final res1 = await http.get(
      Uri.parse("http://10.0.2.2:8000/patient/${widget.patientId}/history"),
      headers: {"Authorization": "Bearer ${widget.token}"},
    );
    final res2 = await http.get(
      Uri.parse("http://10.0.2.2:8000/patient/${widget.patientId}/chatlogs"),
      headers: {"Authorization": "Bearer ${widget.token}"},
    );
    setState(() {
      records = res1.statusCode == 200 ? jsonDecode(res1.body) : [];
      chatlogs = res2.statusCode == 200 ? jsonDecode(res2.body) : [];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.patientName)),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ListTile(
                  title: Text("Medical Records",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ...records.map((r) => ListTile(
                      title: Text(r["filename"]),
                      subtitle: Text("Uploaded: ${r["uploaded"]}\n${r["description"] ?? ""}"),
                    )),
                Divider(),
                ListTile(
                  title: Text("Chatbot History",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ...chatlogs.map((c) => ListTile(
                      title: Text("Q: ${c["message"]}"),
                      subtitle:
                          Text("A: ${c["response"]}\nAt: ${c["timestamp"]}"),
                    )),
              ],
            ),
    );
  }
}