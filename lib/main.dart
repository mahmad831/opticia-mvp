import 'package:flutter/material.dart';
import 'screens/permissions_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

void main() => runApp(const OpticiaApp());

class OpticiaApp extends StatelessWidget {
  const OpticiaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Opticia',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2ECC71),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/permissions',
      routes: {
        '/permissions': (_) => const PermissionsScreen(),
        '/auth': (_) => const AuthScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
