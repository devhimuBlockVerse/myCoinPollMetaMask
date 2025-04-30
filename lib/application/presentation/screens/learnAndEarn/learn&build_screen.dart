import 'package:flutter/material.dart';

class LearnAndBuildScreen extends StatefulWidget {
  const LearnAndBuildScreen({super.key});

  @override
  State<LearnAndBuildScreen> createState() => _LearnAndBuildScreenState();
}

class _LearnAndBuildScreenState extends State<LearnAndBuildScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn & Build'),
        centerTitle: true,
      ),
      body: SafeArea(child: Center(child: Text('Learn & Build Screen', style: TextStyle(color: Colors.white),))),
    );
  }
}

