import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: CryptoStatsApp()));
}

class CryptoStatsApp extends ConsumerWidget {
  const CryptoStatsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Crypto Stats',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode, // Uses the provider value
      home: const HomeScreen(),
    );
  }
}
