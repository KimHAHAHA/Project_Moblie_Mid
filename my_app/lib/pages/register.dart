import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = TextEditingController();
    final pass = TextEditingController();
    final pass2 = TextEditingController();
    final phone = TextEditingController();
    final wallet = TextEditingController();

    void submit() {
      if (user.text.trim().isEmpty ||
          pass.text.isEmpty ||
          pass2.text.isEmpty ||
          phone.text.isEmpty ||
          wallet.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('กรอกข้อมูลให้ครบถ้วน')));
        return;
      }
      if (pass.text != pass2.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('รหัสผ่านไม่ตรงกัน')));
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('สมัครสำเร็จ')));
      Navigator.pop(context); // กลับไปหน้า Login
    }

    InputDecoration deco(String hint) => InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          child: Stack(
            children: [
              // ===== โลโก้ + ปุ่ม Back =====
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
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        '/home_login',
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

                        // ===== ปุ่ม Submit =====
                        SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                              context,
                              '/login',
                            ),
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

                        // ===== ลิงก์ Sign in =====
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
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
}
