import 'package:flutter/material.dart';
import '../services/m3u_parser.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final urls = M3UParser().parse("""
#EXTM3U
http://exemplo.com/canal1.m3u8
""");

    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Playlists')),
      body: ListView.builder(
        itemCount: urls.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(urls[i]),
          onTap: () => Navigator.pushNamed(context, '/player'),
        ),
      ),
    );
  }
}
