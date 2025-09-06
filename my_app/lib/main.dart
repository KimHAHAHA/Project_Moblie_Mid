import 'package:my_app/pages/User/check.dart';
import 'package:my_app/pages/User/mylottery.dart';
import 'package:my_app/pages/User/mywallet.dart';
import 'package:my_app/pages/ad_edit_profile.dart';
import 'package:my_app/pages/ad_home_login.dart';
import 'package:my_app/pages/ad_lucky.dart';
import 'package:my_app/pages/ad_admin.dart';
import 'package:my_app/pages/ad_new_password.dart';
import 'package:my_app/pages/ad_profile.dart';
import 'package:my_app/pages/edit_profile.dart';
import 'package:my_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/home_login.dart';
import 'package:my_app/pages/login.dart';
import 'package:my_app/pages/new_password.dart';
import 'package:my_app/pages/User/profile.dart';
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
      initialRoute: '/home',
      routes: {
        //User
        '/home_login': (context) => const Home_LoginPage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => LoginPage(),
        '/my_lottery': (context) => const MyLotteryPage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
        '/editprofile': (context) => const EditProfilePage(),
        '/check': (context) => const CheckPage(),
        '/mywallet': (context) => const MyWalletPage(),
        '/newpassword': (context) => const NewPasswordPage(),

        //Admin
        '/adhome_login': (context) => const ADHome_LoginPage(),
        '/adlucky': (context) => const ADLuckyPage(),
        '/admin': (context) => const ADAdminPage(),
        '/adprofile': (context) => const ADProfilePage(),
        '/adnewpassword': (context) => const ADNewPasswordPage(),
        '/adeditprofile': (context) => const ADEditProfilePage(),
      },
    );
  }
}

//admin u:admin01 pw:adminpass123
//user u:user01 pw:pass01
