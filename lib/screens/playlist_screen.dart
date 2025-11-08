import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final canais = ['Canal 1', 'Canal 2', 'Canal 3'];

    return Scaffold(
      appBar: AppBar(title: const Text('Playlist')),
      body: ListView.builder(
        itemCount: canais.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(canais[index]),
            onTap: () => Navigator.pushNamed(
              context,
              '/player',
              arguments: {'name': canais[index]},
            ),
          );
        },
      ),
    );
  }
}
