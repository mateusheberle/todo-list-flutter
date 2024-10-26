import 'package:flutter/material.dart';

import 'constants.dart';
import 'view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await getDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'todo list',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Cores.verdinho,
          primary: Cores.verdinho,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
