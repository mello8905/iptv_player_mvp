import 'package:flutter/material.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    final name = args['name'] ?? 'Canal';

    return Scaffold(
      appBar: AppBar(title: Text('Assistindo: $name')),
      body: const Center(
        child: Text('Aqui vai o player de vídeo 🎥'),
      ),
    );
  }
}
