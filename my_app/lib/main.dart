import 'package:my_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/home_login.dart';
import 'package:my_app/pages/login.dart';
import 'package:my_app/pages/mylottery.dart';
import 'package:my_app/pages/profile.dart';
import 'package:my_app/pages/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lottery888',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // กำหนดหน้าแรก
      initialRoute: '/home',
      routes: {
        '/home_login': (context) => const Home_LoginPage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/my_lottery': (context) => const MyLotteryPage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
