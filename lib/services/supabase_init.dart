
import 'package:supabase_flutter/supabase_flutter.dart';

const String supabaseUrl = "https://udjwimjcnekxtww.supabase.co";
const String supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVkaml3amNuZ2tlY2ZoeHdydHd1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI2MzUzODcsImV4cCI6MjA3ODIxMTM4N30.2rs2gZZmBAQeesqDJlG1m_TqMdvWBX6tWp90Urjt9HQ";

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
}
