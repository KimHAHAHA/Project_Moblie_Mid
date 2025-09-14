import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/pages/User/check.dart';
import 'package:my_app/pages/User/login.dart';
import 'package:my_app/pages/User/mylottery.dart';
import 'package:my_app/pages/User/mywallet.dart';
import 'package:my_app/pages/User/profile.dart';
import 'package:my_app/pages/User/register.dart';

class Home_LoginPage extends StatefulWidget {
  final int idx;
  const Home_LoginPage({super.key, required this.idx});

  @override
  State<Home_LoginPage> createState() => _HomePageState();
}

class _HomePageState extends State<Home_LoginPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  int _selectedIndex = 0;

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

  // ---------- PIN container
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

  void _onNavTapped(int i) {
    setState(() => _selectedIndex = i);

    if (widget.idx != 0) {
      switch (i) {
        case 0:
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MyLotteryPage()),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MyWalletPage(idx: widget.idx!)),
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CheckPage()),
          );
          break;
        case 4:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
          break;
      }
    } else {
      switch (i) {
        case 0:
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MyLotteryPage()),
          );
          break;
        case 2: // Login
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
          );
          break;
        case 3: // Register
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegisterPage()),
          );
          break;
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                      setState(() {});
                    }),
                    const SizedBox(width: 12),
                    _darkButton('Confirm', () {}),
                  ],
                ),
                const SizedBox(height: 16),
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
                    itemBuilder: (_, __) => _ticketCard(),
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
            items: (widget.idx != 0)
                ? const [
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
                  ]
                : const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.card_giftcard),
                      label: 'Lottery',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.login),
                      label: 'Login',
                    ),
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

  // void idx() {
  //   try {
  //     var res = await http.put(Uri.parse('$url/customers/${widget.idx}'),
  //         headers: {"Content-Type": "application/json; charset=utf-8"},
  //         body: jsonEncode(json));
  //     log(res.body);
  //     var result = jsonDecode(res.body);
  //     // Need to know json's property by reading from API Tester
  //     log(result['message']);	}catch(err){
  // }
  // }
}
