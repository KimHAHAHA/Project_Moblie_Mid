import 'package:flutter/material.dart';
import 'package:my_app/pages/User/mylottery.dart';
import 'package:my_app/pages/User/mywallet.dart';
import 'package:my_app/pages/User/profile.dart';
import 'package:my_app/pages/User/home_login.dart';

class CheckPage extends StatefulWidget {
  final int idx;
  const CheckPage({super.key, required this.idx});

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  int _selectedIndex = 3;
  Widget _ticketCard(String title, {bool centerTitle = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centerTitle
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: centerTitle ? 0 : 4),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 78,
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: AssetImage('assets/images/Cupong.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _plainTicketBox() {
    return Container(
      height: 78,
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage('assets/images/Cupong.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _darkSmallButton(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3D3D3D),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        elevation: 0,
      ),
      child: Text(label),
    );
  }

  // ====== Nav handler (เรียกหน้าโดยตรง) ======
  void _onNavTapped(int i) {
    setState(() => _selectedIndex = i);
    switch (i) {
      case 0: // Home
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Home_LoginPage(idx: widget.idx)),
        );
        break;
      case 1: // Lottery
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MyLotteryPage(idx: widget.idx)),
        );
        break;
      case 2: // Wallet
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MyWalletPage(idx: widget.idx)),
        );
        break;
      case 3: // Check (อยู่หน้านี้แล้ว)
        break;
      case 4: // Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProfilePage(idx: widget.idx)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Backgroud.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ====== Title + Back (ขวา) ======
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Check',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Home_LoginPage(idx: widget.idx),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ====== เนื้อหาสครอลได้ ======
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Jackpot กลาง
                        Center(
                          child: _ticketCard('Jackpot', centerTitle: true),
                        ),
                        const SizedBox(height: 16),

                        // Second / Third
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ticketCard('Second Prize'),
                            _ticketCard('Third Prize'),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Last 3 / Last 2
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ticketCard('Last 3 Numbers'),
                            _ticketCard('Last 2 Numbers'),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // ปุ่ม Check กลาง (เล็ก สีเข้ม)
                        Center(
                          child: _darkSmallButton('Check', () {
                            // TODO: ใส่ลอจิกตรวจรางวัล
                          }),
                        ),
                        const SizedBox(height: 18),

                        // ส่วนยินดีด้วย...
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ยินดีด้วยคุณถูกรางวัล',
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.black.withOpacity(0.9),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [_plainTicketBox(), _plainTicketBox()],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ====== Bottom Nav 5 เมนู ======
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
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
