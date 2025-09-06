import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 4; // Profile tab

  // ข้อมูลผู้ใช้ (ตัวอย่าง)
  final String username = '123456';
  final String phone = '05484848';

  // นำทาง BottomNavigation
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
        // อยู่หน้า Profile
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0, // ซ่อน AppBar ปกติ
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
                // ===== Title + Back (ไอคอนอยู่ขวา) =====
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.pushReplacementNamed(
                            context,
                            '/home_login',
                          );
                        }
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.black87,
                      splashRadius: 22,
                      tooltip: 'Back',
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // ===== Avatar =====
                Center(
                  child: CircleAvatar(
                    radius: 67,
                    backgroundColor: Colors.black.withOpacity(0.06),
                    child: const Icon(
                      Icons.person,
                      size: 48,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // ===== Card: Username / Phone + ปุ่ม =====
                Center(
                  child: Container(
                    width: 280,
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Username : ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                username,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Phone : ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                phone,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // ปุ่ม Edit Profile (เล็ก สีเข้ม)
                        SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                              context,
                              '/editprofile',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3D3D3D),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: const Text('Edit Profile'),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // ลิงก์ New Password
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                            context,
                            '/newpassword',
                          ),
                          child: const Text(
                            'New Password',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1A73E8),
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // ===== ปุ่ม Logout สีส้มใหญ่ =====
                Center(
                  child: SizedBox(
                    width: 220,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: ลบ token/เซสชันตามจริง
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5A3C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),

      // ===== Bottom Navigation =====
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
