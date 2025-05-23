import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalLocator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Find Hospital")),
      body: Center(
        child: ElevatedButton(
          child: Text("Open Hospitals Near Me (Cameroon)"),
          onPressed: () async {
            final url = "https://www.google.com/maps/search/hospital+Cameroon";
            if (await canLaunch(url)) {
              await launch(url);
            }
          },
        ),
      ),
    );
  }
}