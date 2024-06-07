import 'package:flutter/material.dart';
import 'homepage.dart';

class BubbleTimeApp extends StatelessWidget {
  const BubbleTimeApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubbleTime',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BubbleTime'),
    );
  }
}