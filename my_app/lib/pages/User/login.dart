// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/config/config.dart';
import 'package:my_app/model/request/user_login_post_req.dart';
import 'package:my_app/model/response/user_login_get_res.dart';
import 'package:my_app/pages/Admin/ad_home_login.dart';
import 'package:my_app/pages/User/home_login.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String url = "";

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config["apiEndpoint"];
    });
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration deco(String hint) => InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Backgroud.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/LOGO.png', height: 160),

                    const SizedBox(height: 50),
                    // ===== FORM CARD =====
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: usernameController,
                            decoration: deco("Username"),
                          ),
                          const SizedBox(height: 16),

                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: deco("Password"),
                          ),
                          const SizedBox(height: 20),

                          // ปุ่ม เข้าสู่ระบบ
                          SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                foregroundColor: const Color.fromARGB(
                                  221,
                                  255,
                                  255,
                                  255,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // ลิงก์ สมัครสมาชิก
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/register',
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text(
                                  'Sing up',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login() {
    var data = UserPostRequest(
      username: usernameController.text,
      password: passwordController.text,
    );
    http
        .post(
          Uri.parse("$url/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: userPostRequestToJson(data),
        )
        .then((value) {
          final Map<String, dynamic> res = jsonDecode(value.body);

          if (res['message'] != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(res['message'])));
          }

          UserPostResponse userpostresponse = userPostResponseFromJson(
            value.body,
          );
          if (userpostresponse.role == "member") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home_LoginPage(idx: res['uid']),
              ),
            );
          } else if (userpostresponse.role == "admin") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ADHome_LoginPage()),
            );
          }
        })
        .catchError((error) {
          log('Error $error');
        });
  }
}
