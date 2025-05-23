import 'package:flutter/material.dart';

class PatientRecordsScreen extends StatelessWidget {
  final List<Map<String, String>> records;
  PatientRecordsScreen({required this.records});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Medical Records")),
      body: ListView(
        children: records
            .map((r) => ListTile(
                  title: Text(r["filename"] ?? ""),
                  subtitle: Text(
                      "Uploaded: ${r["uploaded"] ?? ""}\n${r["description"] ?? ""}"),
                ))
            .toList(),
      ),
    );
  }
}