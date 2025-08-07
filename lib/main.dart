import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Music Player',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text('AI Music Player Home')),
      ),
    );
  }
}
