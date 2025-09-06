import 'package:flutter/material.dart';

class MyWalletPage extends StatefulWidget {
  const MyWalletPage({super.key});

  @override
  State<MyWalletPage> createState() => _MyWalletPageState();
}

class _MyWalletPageState extends State<MyWalletPage> {
  int _selectedIndex = 2; // Wallet tab

  // เส้นทางการกดปุ่ม Navigation
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
        // อยู่หน้า Wallet แล้ว
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/check');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
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
        toolbarHeight: 0, // ใช้ SafeArea + Row ทำหัวเอง
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
                // ===== หัวเรื่อง + ปุ่มย้อนกลับ (ขวา) =====
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'My Wallet',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        '/home_login',
                      ),
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.black87,
                      splashRadius: 22,
                      tooltip: 'Back',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ===== การ์ดยอดเงิน สีเหลืองอ่อน =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2B3), // เหลืองอ่อนคล้ายตัวอย่าง
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ยอดเงิน :',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Expanded(
                            child: Text(
                              '100,000.00',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Text(
                              'THB.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // เผื่อพื้นที่ด้านล่างให้โล่งตามตัวอย่าง
                const SizedBox(height: 8),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),

      // ===== แถบนำทางล่าง (5 ปุ่ม) =====
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
                label: 'check',
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
