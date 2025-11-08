import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  final List<String> canais = [
    'Canal 1 - Esportes',
    'Canal 2 - Filmes',
    'Canal 3 - Notícias',
    'Canal 4 - Música',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Canais'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: canais.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(canais[index]),
            trailing: const Icon(Icons.play_circle_fill),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Abrindo ${canais[index]}...')),
              );
            },
          );
        },
      ),
    );
  }
}
