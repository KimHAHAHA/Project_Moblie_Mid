import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  int _selectedIndex = 0;

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  // ==== Logo ====
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

  // ==== PIN box container ====
  Widget _pinContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black26, width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (i) => _pinBox(i)),
      ),
    );
  }

  Widget _pinBox(int index) {
    return SizedBox(
      width: 42,
      height: 50,
      child: TextField(
        controller: _controllers[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  // ==== Button ====
  Widget _darkButton(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3D3D3D),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        elevation: 0,
      ),
      child: Text(label),
    );
  }

  // ==== Ticket Card ====
  Widget _ticketCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage('assets/images/Cupong.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ==== Navigation Tap ====
  void _onNavTapped(int i) {
    setState(() => _selectedIndex = i);
    switch (i) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/login');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/login');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/register');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _logoBlock(),
                const SizedBox(height: 12),

                // กล่อง PIN 6 ช่อง
                _pinContainer(),
                const SizedBox(height: 14),

                // ปุ่ม
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _darkButton('Rondom', () {}),
                    const SizedBox(width: 16),
                    _darkButton('Confirm', () {
                      // TODO: logic confirm
                    }),
                  ],
                ),
                const SizedBox(height: 16),

                // การ์ดลอตเตอรี่
                Expanded(
                  child: GridView.builder(
                    itemCount: 8,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2.15,
                        ),
                    itemBuilder: (context, index) => _ticketCard(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BottomNavigationBar(
            backgroundColor: Colors.white.withOpacity(0.9),
            currentIndex: _selectedIndex,
            onTap: _onNavTapped,
            selectedItemColor: Colors.black87,
            unselectedItemColor: Colors.black54,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard),
                label: 'Lottery',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_add),
                label: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
