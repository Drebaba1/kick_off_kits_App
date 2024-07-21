import 'package:flutter/material.dart';
import 'package:kickoff_kits/views/nav_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF067928),
      body: FutureBuilder(
        future: Future.delayed(
          const Duration(seconds: 3),
          () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => NavBar(),
            ),
            (route) => false,
          ),
        ),
        builder: (context, snapshot) {
          return const Center(
            child: Text(
              'Kickoff Kits',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 66,
                fontFamily: 'Rockwell',
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        },
      ),
    );
  }
}
