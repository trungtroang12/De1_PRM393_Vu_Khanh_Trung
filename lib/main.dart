import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:prm_final/Screens/homepage.dart';
import 'package:prm_final/ViewModel/color_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor =
        ref.watch(colorViewModelProvider).asData?.value ?? 'green';
    Color color = Colors.green;
    if (selectedColor == 'blue') {
      color = Colors.blue;
    } else if (selectedColor == 'purple') {
      color = Colors.purple;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý công việc',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
      ),
      home: const Homepage(),
    );
  }
}
