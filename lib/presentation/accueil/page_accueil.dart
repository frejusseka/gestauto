import 'package:flutter/material.dart';

class PageAccueil extends StatelessWidget {
  const PageAccueil({
    super.key,
  });

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