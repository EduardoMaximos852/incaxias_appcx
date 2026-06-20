import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ⏳ Aguardar 4 segundos antes de abrir a HomePage
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fundo clean

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 Imagem do splash
            SizedBox(
              height: 180,
              width: 180,
              child: Image.asset(
                'assets/imagem/logo.png', // Caminho da sua imagem
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 40),

            // 🔹 Indicador de progresso animado
            const CircularProgressIndicator(
              color: Colors.deepOrange,
              strokeWidth: 3.5,
            ),

            const SizedBox(height: 20),

            const Text(
              "Carregando...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepOrange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
