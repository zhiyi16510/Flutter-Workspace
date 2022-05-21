import 'package:flutter/material.dart';

void main() => runApp(mainScreen());

class mainScreen extends StatefulWidget {
  @override
  State<mainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<mainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY Tutor'),
      ),
      body: Center(
        child: Container(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
