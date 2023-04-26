// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KmFile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'KmFile'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double shakeThreshold = 15.0;
  double lastX = 0.0;
  double lastY = 0.0;
  double lastZ = 0.0;

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      double x = event.x;
      double y = event.y;
      double z = event.z;

      double deltaX = (lastX - x).abs();
      double deltaY = (lastY - y).abs();
      double deltaZ = (lastZ - z).abs();

      if (deltaX > shakeThreshold ||
          deltaY > shakeThreshold ||
          deltaZ > shakeThreshold) {
        // Shake detected
        sendFile();
      }

      lastX = x;
      lastY = y;
      lastZ = z;
    });
  }

  void sendFile() async {
    var file = await FilePicker.platform.pickFiles();

    Share.shareFiles([file!.paths[0]!]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromARGB(255, 75, 19, 230),
      ),
      body: Center(
        child: Column(children: [
          const SizedBox(
            height: 100.0,
          ),
          IconButton(
              onPressed: () {
                sendFile();
              },
              icon: const Icon(
                Icons.share,
                color: Colors.red,
              ))
        ]),
      ),
    );
  }
}
