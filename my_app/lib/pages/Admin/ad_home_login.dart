import 'package:flutter/material.dart';
import 'package:my_app/pages/Admin/ad_admin.dart';
import 'package:my_app/pages/Admin/ad_lucky.dart';

class ADHome_LoginPage extends StatefulWidget {
  final int idx;
  const ADHome_LoginPage({super.key, required this.idx});

  @override
  State<ADHome_LoginPage> createState() => _HomePageState();
}

class _HomePageState extends State<ADHome_LoginPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  int _selectedIndex = 0;

  // รายการเลขที่จะแสดงบนการ์ด
  final List<String> ticketNumbers = const [
    '888888',
    '999999',
    '101010',
    '123456',
    '654321',
    '111111',
    '222222',
    '333333',
  ];

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  Widget _logoBlock() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/LOGO.png',
            height: 70,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _pinContainer() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: Border.all(color: Colors.black26, width: 1.6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, _pinBox),
      ),
    );
  }

  Widget _pinBox(int index) {
    return SizedBox(
      width: 44,
      height: 52,
      child: TextField(
        controller: _controllers[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.only(bottom: 4),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _darkButton(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3D3D3D),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        elevation: 0,
      ),
      child: Text(label),
    );
  }

  // ===== การ์ดคูปองพร้อมตัวเลขด้านบน =====
  Widget _ticketCard(String number) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage('assets/images/Cupong.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // ข้อความตัวเลขด้านบนกึ่งกลาง
          Positioned(
            top: 26,
            left: 20,
            right: 0,
            child: Text(
              number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                shadows: [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.white,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onNavTapped(int i) {
    if (i == _selectedIndex) return;
    setState(() => _selectedIndex = i);
    switch (i) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ADHome_LoginPage(idx: widget.idx)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ADLuckyPage(idx: widget.idx)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ADAdminPage(idx: widget.idx)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Backgroud.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _logoBlock(),
                const SizedBox(height: 10),
                _pinContainer(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _darkButton('Random', () {
                      setState(() {}); // ตรงนี้คุณจะสุ่มเลข/ทำอย่างอื่นก็ได้
                    }),
                    const SizedBox(width: 12),
                    _darkButton('Confirm', () {}),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    itemCount: ticketNumbers.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2.15,
                        ),
                    itemBuilder: (_, index) =>
                        _ticketCard(ticketNumbers[index]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
                icon: Icon(Icons.card_giftcard),
                label: 'Lucky numbers',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Admin',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
