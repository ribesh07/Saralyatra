import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

void main() => runApp(ViewerApp());

class ViewerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ViewerScreen());
  }
}

class ViewerScreen extends StatefulWidget {
  @override
  _ViewerScreenState createState() => _ViewerScreenState();
}

class _ViewerScreenState extends State<ViewerScreen> {
  late WebSocketChannel channel;
  List<dynamic> drivers = [];

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(Uri.parse('ws://<YOUR-IP>:8080'));

    channel.stream.listen((data) {
      final message = jsonDecode(data);
      if (message['type'] == 'DRIVER_LIST') {
        setState(() {
          drivers = message['drivers'];
        });
      }
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Driver List')),
      body: ListView.builder(
        itemCount: drivers.length,
        itemBuilder: (_, index) {
          final driver = drivers[index];
          return ListTile(
            title: Text('Phone: ${driver['phone']}'),
            subtitle:
                Text('Lat: ${driver['latitude']}, Lng: ${driver['longitude']}'),
            trailing: Text(driver['updatedAt']?.substring(11, 19) ?? ''),
          );
        },
      ),
    );
  }
}
