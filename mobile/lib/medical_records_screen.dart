import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MedicalRecord {
  final int id;
  final String filename;
  final DateTime uploadTime;

  MedicalRecord({required this.id, required this.filename, required this.uploadTime});

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'],
      filename: json['filename'],
      uploadTime: DateTime.parse(json['upload_time']),
    );
  }
}

class MedicalRecordsScreen extends StatefulWidget {
  final String token;
  MedicalRecordsScreen({required this.token});

  @override
  _MedicalRecordsScreenState createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  List<MedicalRecord> records = [];

  @override
  void initState() {
    super.initState();
    loadRecords();
  }

  Future<void> loadRecords() async {
    final res = await http.get(
      Uri.parse("http://10.0.2.2:8000/records"),
      headers: {"Authorization": "Bearer ${widget.token}"},
    );
    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body);
      setState(() {
        records = data.map((e) => MedicalRecord.fromJson(e)).toList();
      });
    }
  }

  Future<void> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      var file = result.files.single;
      var request = http.MultipartRequest('POST', Uri.parse("http://10.0.2.2:8000/upload_record"));
      request.headers["Authorization"] = "Bearer ${widget.token}";
      request.files.add(await http.MultipartFile.fromPath('file', file.path!));
      var res = await request.send();
      if (res.statusCode == 200) {
        loadRecords();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Medical Records")),
      body: ListView(
        children: [
          ElevatedButton(onPressed: uploadFile, child: Text("Upload Medical Record")),
          ...records.map((record) => ListTile(
                title: Text(record.filename),
                subtitle: Text("Uploaded: ${record.uploadTime}"),
                onTap: () {
                  // Download or view file logic here
                },
              ))
        ],
      ),
    );
  }
}