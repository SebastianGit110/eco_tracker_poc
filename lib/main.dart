import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: EcoLog()));

class EcoLog extends StatefulWidget {
  @override
  _EcoLogState createState() => _EcoLogState();
}

class _EcoLogState extends State<EcoLog> {
  final List<String> _data = [];
  final TextEditingController _input = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DevOps PoC: Android & Windows")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _input,
              decoration: InputDecoration(labelText: "Nombre del Punto"),
            ),
          ),
          ElevatedButton(
            child: Text("Registrar"),
            onPressed: () => setState(() {
              _data.add(_input.text);
              _input.clear();
            }),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (c, i) => ListTile(title: Text(_data[i])),
            ),
          ),
        ],
      ),
    );
  }
}
