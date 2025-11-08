import 'package:flutter/material.dart';
import 'player_screen.dart';
import '../services/m3u_parser.dart';

class PlaylistScreen extends StatelessWidget {
  final String url;

  const PlaylistScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Canais'),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<List<M3UItem>>(
        future: M3UParser.parse(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhum canal encontrado.', style: TextStyle(color: Colors.white70)),
            );
          }

          final canais = snapshot.data!;
          return ListView.builder(
            itemCount: canais.length,
            itemBuilder: (context, index) {
              final canal = canais[index];
              return ListTile(
                title: Text(canal.title, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerScreen(url: canal.link),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
