import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/config/config.dart';
import 'package:my_app/model/response/lotto_get_res.dart';

import 'package:my_app/pages/User/home_login.dart';
import 'package:my_app/pages/User/mywallet.dart';
import 'package:my_app/pages/User/check.dart';
import 'package:my_app/pages/User/profile.dart';

class MyLotteryPage extends StatefulWidget {
  final int idx;
  const MyLotteryPage({super.key, required this.idx});

  @override
  State<MyLotteryPage> createState() => _MyLotteryPageState();
}

class _MyLotteryPageState extends State<MyLotteryPage> {
  int _selectedIndex = 1;

  List<LottosGetResponse> lottos = [];
  String url = "";
  String errorText = "";
  bool loading = false;

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
    } catch (e, st) {
      log("init error: $e\n$st");
      if (!mounted) return;
      setState(() => errorText = e.toString());
    }
  }

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
  }

  // ===== แสดงป๊อปอัพขึ้นเงิน =====
  void _showCashoutDialog(String number) {
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
                      child: Center(
                        child: Text(
                          number,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                          ),
                        ),
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
                        color: Colors.black87,
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
                    ),
                  ),
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ยอดเงินคงเหลือ',
                      style: TextStyle(
                        color: Colors.black87,
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
                            backgroundColor: Color(0xFF6B5F2D),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Home_LoginPage(idx: widget.idx),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_back, size: 26),
                      color: Colors.black87,
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

              // ===== รายการบัตรจาก API =====
              Expanded(
                child: (loading)
                    ? const Center(child: CircularProgressIndicator())
                    : (lottos.isEmpty)
                    ? const Center(child: Text("ยังไม่มีลอตเตอรี่"))
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
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

      // ===== Bottom Navigation =====
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
                  const Text('ยอดเงินคงเหลือ: 10000.00'),
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

  Future<void> mylotto() async {
    EasyLoading.show(status: 'loading...');

    log(widget.idx.toString());
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

      if (!mounted) return; // ✅ ป้องกัน setState หลัง dispose
      setState(() {
        lottos = decoded;
      });
    } catch (e, st) {
      log("profile error: $e\n$st");
      if (!mounted) return;
      setState(() => errorText = e.toString());
    } finally {
      EasyLoading.dismiss();
      if (mounted) setState(() => loading = false);
    }
  }
}

// ================== Models & Widgets ==================

// class _TicketData {
//   final String number;
//   final bool cashable;
//   const _TicketData({required this.number, required this.cashable});
// }

// class _TicketCard extends StatelessWidget {
//   final String number;
//   final bool cashable;
//   final VoidCallback? onCashout;

//   const _TicketCard({
//     required this.number,
//     required this.cashable,
//     this.onCashout,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.9),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           AspectRatio(
//             aspectRatio: 2.9,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 image: const DecorationImage(
//                   image: AssetImage('assets/images/Cupong.png'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   Positioned(
//                     top: 40,
//                     left: 140,
//                     child: Text(
//                       number,
//                       style: const TextStyle(
//                         fontSize: 36,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 3,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (cashable)
//             Positioned(
//               right: 14,
//               bottom: 10,
//               child: GestureDetector(
//                 onTap: onCashout,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Color(0xFFE94E1B),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Text(
//                     'ขึ้นเงิน',
//                     style: TextStyle(color: Colors.white, fontSize: 12),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
