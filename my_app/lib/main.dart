import 'package:flutter/material.dart';
import 'package:my_app/pages/User/home_login.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
      home: Home_LoginPage(idx: 0),
      builder: EasyLoading.init(),
    );
  }
}

//User name: user01    pw: pass01
//Admin name: 11       pm: 11
