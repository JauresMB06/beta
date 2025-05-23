import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class UploadRecordScreen extends StatefulWidget {
  @override
  State<UploadRecordScreen> createState() => _UploadRecordScreenState();
}

class _UploadRecordScreenState extends State<UploadRecordScreen> {
  PlatformFile? pickedFile;
  final TextEditingController descCtrl = TextEditingController();
  String? token;
  bool isLoading = false;
  String msg = "";

  @override
  void didChangeDependencies() {
    token = ModalRoute.of(context)?.settings.arguments as String?;
    super.didChangeDependencies();
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.isNotEmpty) {
      setState(() => pickedFile = result.files.first);
    }
  }

  Future<void> upload() async {
    if (pickedFile == null || token == null) return;
    setState(() {
      isLoading = true;
      msg = "";
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://10.0.2.2:8000/upload-record/"),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['description'] = descCtrl.text;
    request.files.add(await http.MultipartFile.fromPath('file', pickedFile!.path!));

    final resp = await request.send();
    setState(() => isLoading = false);
    if (resp.statusCode == 200) {
      setState(() => msg = "Upload successful!");
    } else {
      setState(() => msg = "Failed to upload.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Medical Record")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: Text(pickedFile == null ? "Pick File" : pickedFile!.name),
            ),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(labelText: "Description"),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : upload,
              child: isLoading ? CircularProgressIndicator() : Text("Upload"),
            ),
            if (msg.isNotEmpty) Text(msg),
          ],
        ),
      ),
    );
  }
}