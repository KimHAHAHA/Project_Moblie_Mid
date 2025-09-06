import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/config/config.dart';

class MyWalletPage extends StatefulWidget {
  // รับ idx แบบชัดเจน
  final int idx;
  const MyWalletPage({super.key, required this.idx});

  @override
  State<MyWalletPage> createState() => _MyWalletPageState();
}

class _MyWalletPageState extends State<MyWalletPage> {
  int _selectedIndex = 2;

  // ค่า config + สถานะการโหลด
  String url = "";
  String? balanceText; // ข้อความยอดเงินที่จะแสดง
  String? errorText; // ข้อความ error หากมี
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _init(); // โหลด config แล้วค่อยยิง API
  }

  Future<void> _init() async {
    try {
      final config = await Configuration.getConfig();
      url = (config["apiEndpoint"] as String).trim();
      await wallet(); // รอให้ได้ url ก่อนแล้วค่อยเรียก API
    } catch (e, st) {
      log("init error: $e\n$st");
      if (!mounted) return;
      setState(() => errorText = e.toString());
    }
  }

  Future<void> wallet() async {
    if (url.isEmpty) return;

    setState(() {
      loading = true;
      errorText = null;
    });

    try {
      // เขียนแบบปลอดภัยกับ path ได้เช่นกัน:
      // final uri = Uri.parse(url).replace(path: "/profile/wallet/${widget.idx}");
      final uri = Uri.parse("$url/profile/wallet/${widget.idx}");
      log("GET $uri");

      final res = await http.get(
        uri,
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );

      if (res.statusCode != 200) {
        throw Exception("HTTP ${res.statusCode}: ${res.body}");
      }

      final decoded = jsonDecode(res.body);
      log("decoded type = ${decoded.runtimeType}");

      // รองรับทั้ง List และ Map
      Map<String, dynamic> row;
      if (decoded is List && decoded.isNotEmpty) {
        row = decoded.first as Map<String, dynamic>;
      } else if (decoded is Map<String, dynamic>) {
        row = decoded;
      } else {
        throw Exception("Unexpected JSON shape");
      }

      // ดึงค่า wallet_balance (เป็น string) แล้วแปลงเป็นตัวเลข
      final raw = row['wallet_balance'] ?? row['balance'] ?? row['amount'] ?? 0;
      final num balance = raw is num
          ? raw
          : (num.tryParse(raw.toString()) ?? 0);

      if (!mounted) return;
      setState(() {
        balanceText = balance.toStringAsFixed(2); // "10000.00"
      });

      // log ทั้ง object (แปลงเป็น string ก่อน)
      log("wallet row: ${jsonEncode(row)}");
    } catch (e, st) {
      log("wallet error: $e\n$st");
      if (!mounted) return;
      setState(() => errorText = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
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
    final showBalance = balanceText ?? '—';

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
                // หัวข้อ + ปุ่ม Back
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

                // การ์ดยอดเงิน
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2B3),
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
                        children: [
                          Expanded(
                            child: Text(
                              loading ? 'กำลังโหลด...' : showBalance,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Padding(
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
                      if (errorText != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Error: $errorText',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),

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
