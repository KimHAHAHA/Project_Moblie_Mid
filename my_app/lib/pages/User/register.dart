import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/config/config.dart';
import 'package:my_app/model/request/user_register_post_req.dart';
import 'package:my_app/pages/User/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var user = TextEditingController();
  var pass = TextEditingController();
  var pass2 = TextEditingController();
  var phone = TextEditingController();
  var wallet = TextEditingController();

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
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Backgroud.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/LOGO.png',
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 26),
                      color: Colors.black87,
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      ),
                      tooltip: 'Back',
                      splashRadius: 22,
                    ),
                  ],
                ),
              ),

              // ===== ฟอร์ม Register =====
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ===== ชื่อผู้ใช้ =====
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
                          controller: user,
                          decoration: deco('Username'),
                        ),
                        const SizedBox(height: 14),

                        // ===== รหัสผ่าน =====
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
                          controller: pass,
                          obscureText: true,
                          decoration: deco('Password'),
                        ),
                        const SizedBox(height: 14),

                        // ===== ยืนยันรหัสผ่าน =====
                        const Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: pass2,
                          obscureText: true,
                          decoration: deco('Confirm Password'),
                        ),
                        const SizedBox(height: 14),

                        // ===== เบอร์โทรศัพท์ =====
                        const Text(
                          'Phone',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: phone,
                          keyboardType: TextInputType.phone,
                          decoration: deco('Phone'),
                        ),
                        const SizedBox(height: 14),

                        // ===== Wallet =====
                        const Text(
                          'Wallet',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: wallet,
                          decoration: deco('Wallet'),
                        ),
                        const SizedBox(height: 18),

                        SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            onPressed: register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                'Sign in',
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    if (user.text.trim().isEmpty ||
        pass.text.isEmpty ||
        pass2.text.isEmpty ||
        phone.text.isEmpty ||
        wallet.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('กรอกข้อมูลให้ครบถ้วน')));
    }

    if (pass.text != pass2.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('รหัสผ่านไม่ตรงกัน')));
    } else {
      var userregister = UserRegisterPostRequest(
        username: user.text,
        password: pass.text,
        phone: phone.text,
        walletBalance: int.parse(wallet.text),
      );

      http
          .post(
            Uri.parse("$url/register"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: userRegisterPostRequestToJson(userregister),
          )
          .then((value) {
            final Map<String, dynamic> res = jsonDecode(value.body);
            if (res['message'] == 'ลงทะเบียนสำเร็จ') {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('สมัครสำเร็จ')));
              var message = Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            } else {
              var data = res['message'];
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(data)));
            }
          })
          .catchError((error) {
            log('Error $error');
          });
    }
  }
}
