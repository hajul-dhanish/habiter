import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:provider/provider.dart';
import 'package:habiter/providers/habit_provider.dart';
import 'package:habiter/providers/journal_provider.dart';
import 'package:habiter/services/database_service.dart';
import 'package:habiter/theme/app_theme.dart';
import 'package:habiter/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar
  await DatabaseService.initialize();

  runApp(const rp.ProviderScope(child: HabiterApp()));
}

class HabiterApp extends StatelessWidget {
  const HabiterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitProvider()..fetchHabits()),
        ChangeNotifierProvider(
          create: (_) => JournalProvider()..fetchEntries(),
        ),
      ],
      child: MaterialApp(
        title: 'Habiter',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const MainScreen(),
      ),
    );
  }
}
