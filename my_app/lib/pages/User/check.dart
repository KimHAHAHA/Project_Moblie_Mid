import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/config/config.dart';
import 'package:my_app/model/response/lotto_get_res.dart';
import 'package:my_app/model/response/rewards_get_res.dart';
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
  List<LottosGetResponse> lottos = [];
  List<RewardGetResponse> rewards = [];

  String url = "";
  String errorText = "";
  bool loading = false;

  bool showResult = false; // ✅ ควบคุมการแสดงผลการ์ดล่าง

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final config = await Configuration.getConfig();
      url = (config["apiEndpoint"] as String).trim();
      await mylotto();
      await getrewards();
    } catch (e, st) {
      log("init error: $e\n$st");
      if (!mounted) return;
      setState(() => errorText = e.toString());
    }
  }

  // ✅ การ์ด (รองรับ onTap)
  Widget _ticketCard(
    String title, {
    bool centerTitle = false,
    String? number,
    VoidCallback? onTap,
  }) {
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
        InkWell(
          onTap: onTap,
          child: Container(
            height: 78,
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage('assets/images/Cupong.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Text(
                number ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ✅ ปุ่มสีเข้ม
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

  // ✅ Popup แจ้งรางวัล
  void _showPrizeDialog(String number, String prizeName, String amount) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFFF9E6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "$prizeName !!!",
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('assets/images/Cupong.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  number,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "ยินดีด้วย คุณถูกรางวัล\nเงินรางวัลมูลค่า $amount บาท",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ยกเลิก"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              // TODO: ไปหน้า "ขึ้นเงิน"
            },
            child: const Text("ขึ้นเงิน"),
          ),
        ],
      ),
    );
  }

  // ✅ Bottom Navigation
  void _onNavTapped(int i) {
    setState(() => _selectedIndex = i);
    switch (i) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Home_LoginPage(idx: widget.idx)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MyLotteryPage(idx: widget.idx)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MyWalletPage(idx: widget.idx)),
        );
        break;
      case 3:
        break;
      case 4:
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
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Check',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: _ticketCard(
                            'Jackpot',
                            centerTitle: true,
                            number: '000000',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ticketCard('Second Prize', number: '111111'),
                            _ticketCard('Third Prize', number: '222222'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ticketCard('Last 3 Numbers', number: '333333'),
                            _ticketCard('Last 2 Numbers', number: '555555'),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // ปุ่ม Check
                        Center(
                          child: _darkSmallButton('Check', () {
                            setState(() {
                              showResult = true;
                            });
                          }),
                        ),
                        const SizedBox(height: 18),

                        // แสดงการ์ดล่างเมื่อกด Check
                        if (showResult) ...[
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
                            children: [
                              _ticketCard(
                                'My Prize',
                                number: '999999',
                                onTap: () => _showPrizeDialog(
                                  '999999',
                                  'Jackpot',
                                  '6,000,000',
                                ),
                              ),
                              _ticketCard(
                                'My Prize',
                                number: '555555',
                                onTap: () => _showPrizeDialog(
                                  '555555',
                                  'Second Prize',
                                  '200,000',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
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

  // ฟังก์ชันโหลดข้อมูล (ยังคงไว้)
  Future<void> mylotto() async {
    EasyLoading.show(status: 'loading...');
    try {
      final uri = Uri.parse("$url/lottery/${widget.idx}");
      final res = await http.get(
        uri,
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );
      if (res.statusCode != 200) {
        throw Exception("HTTP ${res.statusCode}: ${res.body}");
      }
      var decoded = lottosGetResponseFromJson(res.body);
      if (!mounted) return;
      setState(() {
        lottos = decoded;
      });
    } catch (e, st) {
      log("lotto error: $e\n$st");
      if (!mounted) return;
      setState(() => errorText = e.toString());
    } finally {
      EasyLoading.dismiss();
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> getrewards() async {
    EasyLoading.show(status: 'loading...');
    try {
      final uri = Uri.parse("$url/lottery/rewards");
      final res = await http.get(
        uri,
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );
      if (res.statusCode != 200) {
        throw Exception("HTTP ${res.statusCode}: ${res.body}");
      }
      var decoded = rewardGetResponseFromJson(res.body);
      if (!mounted) return;
      setState(() {
        rewards = decoded;
      });
    } catch (e, st) {
      log("reward error: $e\n$st");
      if (!mounted) return;
      setState(() => errorText = e.toString());
    } finally {
      EasyLoading.dismiss();
      if (mounted) setState(() => loading = false);
    }
  }
}
