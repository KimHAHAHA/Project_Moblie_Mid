import 'package:flutter/material.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPassCtl = TextEditingController(text: '99999999');
  final _newPassCtl = TextEditingController();
  final _confirmPassCtl = TextEditingController();

  int _selectedIndex = 4; // Profile tab

  @override
  void dispose() {
    _oldPassCtl.dispose();
    _newPassCtl.dispose();
    _confirmPassCtl.dispose();
    super.dispose();
  }

  void _onNavTapped(int i) {
    setState(() => _selectedIndex = i);
    switch (i) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home_login');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/my_lottery');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/mywallet');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/check');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  // กล่องอินพุตแบบไม่มี label/hint ภายใน
  InputDecoration _boxDecoration() => InputDecoration(
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
  );

  // วิดเจ็ตฟิลด์มาตรฐาน: ชื่อด้านบน + กล่องกรอก
  Widget _field({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: _boxDecoration(), // ไม่มี label/hint ในช่อง
          validator: validator,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Backgroud.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + Back (ขวา)
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'New Password',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/profile'),
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.black87,
                      splashRadius: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Avatar
                Center(
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.white.withOpacity(0.95),
                    child: const Icon(
                      Icons.person_outline,
                      size: 62,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ฟอร์มการ์ด
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E5E5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _field(
                              label: 'Password',
                              controller: _oldPassCtl,
                              obscure: true,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'กรอกรหัสผ่านเดิม'
                                  : null,
                            ),
                            const SizedBox(height: 14),
                            _field(
                              label: 'New Password',
                              controller: _newPassCtl,
                              obscure: true,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'กรอกรหัสผ่านใหม่'
                                  : null,
                            ),
                            const SizedBox(height: 14),
                            _field(
                              label: 'Confirm Password',
                              controller: _confirmPassCtl,
                              obscure: true,
                              validator: (v) => v != _newPassCtl.text
                                  ? 'รหัสไม่ตรงกัน'
                                  : null,
                            ),
                            const SizedBox(height: 18),

                            // ปุ่ม
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/profile',
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF3D3D3D),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text('ยกเลิก'),
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        // TODO: บันทึกรหัสใหม่
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/profile',
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF3D3D3D),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text('บันทึก'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BottomNavigationBar(
            backgroundColor: Colors.white.withOpacity(0.92),
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onNavTapped,
            selectedItemColor: Colors.black87,
            unselectedItemColor: Colors.black54,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.confirmation_number_outlined),
                label: 'Lottery',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined),
                label: 'Wallet',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fact_check_outlined),
                label: 'Check',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
