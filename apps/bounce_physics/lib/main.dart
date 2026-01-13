import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/scores_screen.dart';
import 'screens/instructions_screen.dart';

void main() {
  runApp(const BouncePhysicsApp());
}

class BouncePhysicsApp extends StatelessWidget {
  const BouncePhysicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BouncePhysics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/game': (context) => const GameScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/scores': (context) => const ScoresScreen(),
        '/instructions': (context) => const InstructionsScreen(),
      },
    );
  }
}
