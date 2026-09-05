import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import '../milk/screens/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: LactouzApp()));
}

class LactouzApp extends StatelessWidget {
  const LactouzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lactouz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DashboardScreen(),
    );
  }
}
