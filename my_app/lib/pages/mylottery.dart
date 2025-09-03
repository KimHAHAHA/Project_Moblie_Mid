import 'package:flutter/material.dart';

class MyLotteryPage extends StatefulWidget {
  const MyLotteryPage({super.key});

  @override
  State<MyLotteryPage> createState() => _MyLotteryPageState();
}

class _MyLotteryPageState extends State<MyLotteryPage> {
  int _selectedIndex = 1; // ตำแหน่ง Lottery

  // เส้นทางการกดปุ่ม Navigation
  void _onNavTapped(int i) {
    setState(() => _selectedIndex = i);
    switch (i) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home_login');
        break;
      case 1:
        // อยู่ที่ Lottery แล้ว
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/wallet');
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
    // ข้อมูลตัวอย่าง: เลข + สถานะว่าขึ้นเงินได้ไหม
    final tickets = const [
      _TicketData(number: '888888', date: '1 ก.ค. 2568', cashable: false),
      _TicketData(number: '999999', date: '1 ก.ค. 2568', cashable: false),
      _TicketData(number: '101010', date: '1 ก.ค. 2568', cashable: false),
    ];

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== หัวเรื่อง + ปุ่มย้อนกลับ =====
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Lottery',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        '/home_login',
                      ),
                      icon: const Icon(Icons.arrow_back, size: 26),
                      color: Colors.black87,
                      splashRadius: 22,
                      tooltip: 'Back',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'รายการ Lottery :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),

              // ===== รายการบัตรแบบแนวตั้ง =====
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                  itemCount: tickets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final t = tickets[index];
                    return _TicketCard(
                      number: t.number,
                      date: t.date,
                      cashable: t.cashable,
                    );
                  },
                ),
              ),
            ],
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

// ================== Widgets / Models ==================

class _TicketData {
  final String number;
  final String date;
  final bool cashable;
  const _TicketData({
    required this.number,
    required this.date,
    required this.cashable,
  });
}

class _TicketCard extends StatelessWidget {
  final String number;
  final String date;
  final bool cashable;
  const _TicketCard({
    required this.number,
    required this.date,
    required this.cashable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // card พื้นหลังคูปอง
          AspectRatio(
            aspectRatio: 2.9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/Cupong.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // วันที่มุมขวาบน
                  Positioned(
                    right: 10,
                    top: 8,
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // เลขตรงกลาง
                  Center(
                    child: Text(
                      number,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ปุ่ม "ขึ้นเงิน" มุมขวาล่าง (เฉพาะใบที่ cashable)
          if (cashable)
            Positioned(
              right: 14,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE94E1B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ขึ้นเงิน',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
