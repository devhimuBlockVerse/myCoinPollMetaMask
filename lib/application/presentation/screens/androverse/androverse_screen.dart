import 'package:flutter/material.dart';

class AndroVerseScreen extends StatefulWidget {
  const AndroVerseScreen({super.key});

  @override
  State<AndroVerseScreen> createState() => _AndroVerseScreenState();
}

class _AndroVerseScreenState extends State<AndroVerseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Androverse'),
        centerTitle: true,
      ),
      body: SafeArea(child: Center(child: Text('Androverse Screen', style: TextStyle(color: Colors.white),))),
    );
  }
}
