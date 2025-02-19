import 'package:flutter/material.dart';
import 'package:chokro_byte/feature/facilitiessection.dart';
import 'package:chokro_byte/feature/hoverbutton.dart';
import 'package:chokro_byte/feature/welcomesection.dart';
import 'package:chokro_byte/feature/whychooseus.dart';

void main() {
  runApp(ChokroByteApp());
}

class ChokroByteApp extends StatefulWidget {
  @override
  _ChokroByteAppState createState() => _ChokroByteAppState();
}

class _ChokroByteAppState extends State<ChokroByteApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF00244C),
          title: Row(
            children: [
              Text(
                "CHOKRO",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "byte",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            HoveringButtonSection(label: 'Home'),
            SizedBox(width: 10),
            HoveringButtonSection(label: 'Services'),
            SizedBox(width: 10),
            HoveringButtonSection(label: 'Our Team'),
            SizedBox(width: 10),
            HoveringButtonSection(label: 'Contact'),
            SizedBox(width: 10),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WelcomeSection(),
                SizedBox(height: 20),
                Divider(thickness: 5, color: Colors.black),
                SizedBox(height: 25),
                FacilitiesSection(),
                SizedBox(height: 20),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                Whychooseus(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
