import 'package:flutter/material.dart';

// === ปรับ path ให้ตรงกับโปรเจกต์คุณ ===
import 'package:my_app/pages/User/home_login.dart';
import 'package:my_app/pages/User/mywallet.dart';
import 'package:my_app/pages/User/check.dart';
import 'package:my_app/pages/User/profile.dart';

class MyLotteryPage extends StatefulWidget {
  final int idx; // เผื่อส่งต่อไป Wallet
  const MyLotteryPage({super.key, required this.idx});

  @override
  State<MyLotteryPage> createState() => _MyLotteryPageState();
}

class _MyLotteryPageState extends State<MyLotteryPage> {
  int _selectedIndex = 1; // ตำแหน่ง Lottery

  // เส้นทางการกดปุ่ม Navigation (เรียกหน้าโดยตรง)
  void _onNavTapped(int i) {
    setState(() => _selectedIndex = i);
    switch (i) {
      case 0: // Home
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Home_LoginPage(idx: widget.idx ?? 0),
          ),
        );
        break;

      case 1: // Lottery (อยู่หน้านี้แล้ว)
        break;

      case 2: // Wallet
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MyWalletPage(idx: widget.idx ?? 0)),
        );
        break;

      case 3: // Check
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CheckPage(idx: widget.idx)),
        );
        break;

      case 4: // Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProfilePage(idx: widget.idx)),
        );
        break;
    }
  }

  // ===== แสดงป๊อปอัพขึ้นเงิน =====
  void _showCashoutDialog(String number, String date) {
    final gotAmountCtl = TextEditingController(text: '6 000 000');
    final feeCtl = TextEditingController(text: '200');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEEDD9E),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  const Text(
                    'Jackpot !!!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),

                  // บัตรคูปองในป๊อปอัพ
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

                  const SizedBox(height: 12),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ยินดีด้วย คุณถูกรางวัลที่ 1\nเงินรางวัลมูลค่า 6,000,000 บาท',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ยอดเงินที่จะได้รับ',
                      style: TextStyle(
                        color: Colors.black87.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: gotAmountCtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ยอดเงินคงเหลือ',
                      style: TextStyle(
                        color: Colors.black87.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: feeCtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('ยกเลิก'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('ดำเนินการขึ้นเงินเรียบร้อย'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B5F2D),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('ขึ้นเงิน'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tickets = const [
      _TicketData(number: '888888', date: '1 ก.ค. 2568', cashable: false),
      _TicketData(number: '999999', date: '1 ก.ค. 2568', cashable: false),
      _TicketData(number: '101010', date: '1 ก.ค. 2568', cashable: true),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
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
              // ===== หัวเรื่อง + ปุ่มย้อนกลับ (เรียกหน้าโดยตรง) =====
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                Home_LoginPage(idx: widget.idx ?? 0),
                          ),
                        );
                      },
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
                      onCashout: () => _showCashoutDialog(t.number, t.date),
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
  final VoidCallback? onCashout;

  const _TicketCard({
    super.key,
    required this.number,
    required this.date,
    required this.cashable,
    this.onCashout,
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

          if (cashable)
            Positioned(
              right: 14,
              bottom: 10,
              child: GestureDetector(
                onTap: onCashout,
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
            ),
        ],
      ),
    );
  }
}
