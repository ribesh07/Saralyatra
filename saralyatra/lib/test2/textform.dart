import 'package:flutter/material.dart';

class Textformtest extends StatefulWidget {
  const Textformtest({super.key});

  @override
  State<Textformtest> createState() => _TextformtestState();
}

class _TextformtestState extends State<Textformtest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        child: TextFormField(
          decoration: InputDecoration(label: Text("hola"), hintText: "hola"),
          onTap: () {
            items:
            [
              DropdownMenuItem(value: -1, child: Text("To")),
              DropdownMenuItem(value: 1, child: Text("Tinkune")),
              DropdownMenuItem(value: 2, child: Text("Gaushala")),
              DropdownMenuItem(value: 3, child: Text("Kalanki")),
            ];
          },
        ),
      ),
    );
  }
}
