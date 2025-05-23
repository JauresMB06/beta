// in your records ListView:
...records.map((r) => ListTile(
  title: Text(r["filename"]),
  subtitle: Text("Uploaded: ${r["uploaded"]}\n${r["description"] ?? ""}"),
)),