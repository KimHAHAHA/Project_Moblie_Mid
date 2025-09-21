import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/config/config.dart';
import 'package:my_app/model/request/user_buy_post_req.dart';
import 'package:my_app/model/response/lotto_get_res.dart';
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
  List<LottosGetResponse> lottos = [];
  List<LottosGetResponse> allLottos = [];

  String url = "";
  String errorText = "";
  bool loading = false;

  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    log("initState เรียกแล้ว");
    _init();
  }

  Future<void> _init() async {
    try {
      final config = await Configuration.getConfig();
      url = (config["apiEndpoint"] as String).trim();
      await _fetchLottoData();
    } catch (e, st) {
      log("init error: $e\n$st");
      if (!mounted) return;
      setState(() => errorText = e.toString());
    }
  }

  int _selectedIndex = 0;

  void _fillFromRandomLotto() {
    if (allLottos.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ไม่มีข้อมูลสลากให้สุ่ม')));
      return;
    }

    final rnd = math.Random();
    // ✅ สุ่มเลือก 1 ใบจากรายการทั้งหมด
    final randomLotto = allLottos[rnd.nextInt(allLottos.length)];

    // ✅ กรอกตัวเลขของสลากนั้นลงใน 6 ช่อง
    final number = randomLotto.lottoNumber.padLeft(
      6,
      '0',
    ); // กันกรณีเลขไม่ครบ 6 หลัก
    for (var i = 0; i < _controllers.length; i++) {
      _controllers[i].text = number[i];
    }
  }

  void _resetPins() {
    // เคลียร์ตัวเลขในทุกช่อง
    for (final c in _controllers) {
      c.clear();
    }

    // แสดงรายการลอตเตอรี่ทั้งหมดกลับมา
    setState(() {
      lottos = List.from(allLottos);
    });

    // เอาโฟกัสออกจาก text field
    FocusScope.of(context).unfocus();
  }

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

  Widget _ticketCard(LottosGetResponse lotto) {
    return InkWell(
      onTap: () {
        if (widget.idx != 0) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: const Color(0xFFFFF9E6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'คุณต้องการเลือกซื้อหรือไม่',
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('หมายเลขที่: ${lotto.lottoNumber}'),
                  Text('ราคา: ${lotto.price}'),
                  Text('สถานะ: ${lotto.lottoStatus}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ยกเลิก'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Home_LoginPage(idx: widget.idx),
                      ),
                    );
                    _onBuy(widget.idx, lotto.lid); // ✅ เรียก API ซื้อ
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('กรุณาเข้าสู่ระบบก่อนซื้อ')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
            image: AssetImage('assets/images/Cupong.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 28,
              left: 70,
              child: Text(
                lotto.lottoNumber,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
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
            MaterialPageRoute(builder: (_) => MyLotteryPage(idx: widget.idx)),
          );
          log(widget.idx.toString());
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MyWalletPage(idx: widget.idx)),
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CheckPage(idx: widget.idx)),
          );
          break;
        case 4:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProfilePage(idx: widget.idx)),
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
            MaterialPageRoute(builder: (_) => LoginPage()),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegisterPage()),
          );
          break;
      }
    }
  }

  @override
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
                    _darkButton('Random', _fillFromRandomLotto),
                    const SizedBox(width: 12),
                    _darkButton('Confirm', _searchLottoByNumber),
                    const SizedBox(width: 12),
                    _darkButton('Reset', _resetPins),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    itemCount: lottos.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2.15,
                        ),
                    itemBuilder: (_, index) => _ticketCard(lottos[index]),
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

  Future<void> _fetchLottoData() async {
    EasyLoading.show(status: 'loading...');
    try {
      final uri = Uri.parse("$url/lottery");
      final res = await http.get(
        uri,
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );

      if (res.statusCode != 200) {
        throw Exception("HTTP ${res.statusCode}: ${res.body}");
      }

      final decoded = lottosGetResponseFromJson(res.body);

      if (!mounted) return;
      setState(() {
        allLottos = decoded; // ✅ เก็บต้นฉบับ
        lottos = decoded; // ✅ แสดงเริ่มต้นทั้งหมด
      });
    } catch (e, st) {
      log("lottos error: $e\n$st");
      if (!mounted) return;
      setState(() => errorText = e.toString());
    } finally {
      if (mounted) {
        EasyLoading.dismiss();
        setState(() => loading = false);
      }
    }
  }

  // ฟังก์ชันค้นหา
  void _searchLottoByNumber() {
    final number = _controllers.map((c) => c.text).join();

    if (number.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณากรอกเลขให้ครบ 6 หลัก")),
      );
      return;
    }

    final results = allLottos.where((l) => l.lottoNumber == number).toList();

    if (results.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("ไม่พบหมายเลข $number")));
    }

    setState(() {
      lottos = results;
    });
  }

  Future<void> _onBuy(int uid, int lid) async {
    try {
      var data = UserBuyPostRequest(uid: uid, lid: lid);

      final response = await http.post(
        Uri.parse("$url/lottery/buy"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: userBuyPostRequestToJson(data),
      );

      final Map<String, dynamic> res = jsonDecode(response.body);

      if (!mounted) return;

      if (res['message'] != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res['message'])));
      }
    } catch (e, st) {
      log("lottery buy error: $e\n$st");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เกิดข้อผิดพลาด กรุณาลองใหม่')),
      );
    }
  }
}
