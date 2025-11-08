import 'package:iptv_player_mvp/screens/login_screen.dart';
import 'package:iptv_player_mvp/screens/playlist_screen.dart';
import 'package:iptv_player_mvp/screens/player_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IPTV Player',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/playlist': (context) => const PlaylistScreen(),
        '/player': (context) => const PlayerScreen(),
      },
    );
  }
}
