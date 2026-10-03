import 'package:flutter/material.dart';

void main() {
  runApp(const Gestauto());
}

class Gestauto extends StatelessWidget {
  const Gestauto({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GESTAUTO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const Accueil(),
    );
  }
}

class Accueil extends StatelessWidget {
  const Accueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GESTAUTO'),
      ),
      body: const Center(
        child: Text(
          'Bienvenue dans GESTAUTO',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}