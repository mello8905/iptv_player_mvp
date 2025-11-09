import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Estilo de cores IBO MAX
const Color kIbBg = Color(0xFF0B0E1A);      // azul marinho bem escuro
const Color kIbPrimary = Color(0xFF6C63FF); // roxo
const Color kIbText = Colors.white;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _deviceId;     // MAC ou ANDROID_ID
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _resolveDeviceId();
  }

  Future<void> _resolveDeviceId() async {
    try {
      String? mac;
      // 1) tenta obter MAC do Wi-Fi (Android antigos)
      if (Platform.isAndroid) {
        final info = NetworkInfo();
        mac = await info.getWifiBSSID(); // alguns devices retornam MAC real; outros não
        // getWifiBSSID retorna BSSID (AP), mas se vier nulo/02:00..., vamos para ANDROID_ID
        if (mac != null && mac.trim().isNotEmpty && mac != '02:00:00:00:00:00') {
          setState(() => _deviceId = mac.toUpperCase());
          return;
        }
        // 2) fallback estável: ANDROID_ID
        final di = DeviceInfoPlugin();
        final android = await di.androidInfo;
        final id = android.id; // ANDROID_ID
        setState(() => _deviceId = id.toUpperCase());
        return;
      } else if (Platform.isIOS) {
        // iOS: use identifierForVendor como “MAC”
        final di = DeviceInfoPlugin();
        final ios = await di.iosInfo;
        final id = ios.identifierForVendor ?? 'UNKNOWN';
        setState(() => _deviceId = id.toUpperCase());
        return;
      } else {
        setState(() => _deviceId = 'UNKNOWN');
      }
    } catch (e) {
      setState(() {
        _deviceId = 'UNKNOWN';
        _error = 'Não foi possível identificar o dispositivo.';
      });
    }
  }

  Future<void> _prosseguir() async {
    if (_deviceId == null || _deviceId == 'UNKNOWN') {
      setState(() => _error = 'Não foi possível ler o identificador do aparelho.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final supabase = Supabase.instance.client;

      // Busca na tabela `clientes` pelo campo `endereco_mac`
      final resp = await supabase
          .from('clientes')
          .select<Map<String, dynamic>>()
          .eq('endereco_mac', _deviceId)
          .maybeSingle();

      if (resp == null) {
        // não achou
        setState(() {
          _error = 'Suporte com seu revendedor';
          _loading = false;
        });
        return;
      }

      final isActive = (resp['is_active'] as bool?) ?? false;
      final expiresAt = resp['expira_em'] as String?;
      final now = DateTime.now().toUtc();
      bool notExpired = true;
      if (expiresAt != null) {
        final dt = DateTime.tryParse(expiresAt);
        if (dt != null) {
          notExpired = dt.toUtc().isAfter(now);
        }
      }

      if (isActive && notExpired) {
        // OK → navega para a tela principal/playlist
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/playlist');
      } else {
        setState(() {
          _error = 'Suporte com seu revendedor';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro ao validar. Tente novamente.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kIbBg,
      textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme)
          .apply(bodyColor: kIbText, displayColor: kIbText),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kIbPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
    );

    return Theme(
      data: theme,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  'IBO MAX',
                  style: GoogleFonts.montserrat(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Mensagem explicativa
                Text(
                  'Você ainda não carregou sua lista.\n'
                  'Para continuar, use seu acesso por MAC (IBO Revenda).',
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),

                const Spacer(),

                // “Endereço MAC” (mostrando o id que resolvemos)
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'endereço MAC',
                        style: TextStyle(color: Colors.white60),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (_deviceId ?? '---').replaceAll('-', ':'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.robotoMono(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFFE082), // amarelo suave
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (_error != null)
                  Center(
                    child: Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w600),
                    ),
                  ),

                const SizedBox(height: 16),

                // Botões
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _loading ? null : _prosseguir,
                        child: _loading
                            ? const SizedBox(
                                width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('PROSSEGUIR'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        ),
                        onPressed: _loading ? null : () => exit(0),
                        child: const Text('CANCELAR'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),
                // Rodapé com site/markdown
                Center(
                  child: Text(
                    'Suporte com seu revendedor',
                    style: const TextStyle(color: Colors.white54),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
