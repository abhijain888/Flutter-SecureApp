import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secure Window"),
      ),
      body: const Center(
        child: Column(
          children: [
            FlutterLogo(
              size: 350,
            ),
          ],
        ),
      ),
    );
  }
}
