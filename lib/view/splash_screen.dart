import 'package:flutter/material.dart';
import 'package:todo_list_flutter_ebac/view/home_page.dart';

import '../constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(
        const Duration(seconds: 2), () {}); // Duração da splash screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ), // Substitua pelo nome da tela principal do seu app
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.preto,
      body: Center(
        child: Image.asset(
            'assets/logo.png'), // Substitua pelo caminho da sua imagem
      ),
    );
  }
}
