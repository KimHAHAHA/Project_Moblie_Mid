import 'dart:convert';
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
  RewardGetResponse? rewardJackpot;
  RewardGetResponse? rewardSecond;
  RewardGetResponse? rewardThird;
  RewardGetResponse? rewardLast3;
  RewardGetResponse? rewardLast2;
  List<RewardGetResponse> myWinningRewards = [];
  Map<int, RewardGetResponse> myWinsByRank = {};
  bool get hasWin => myWinningRewards.isNotEmpty;

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
      await getrewards();
    } catch (e, st) {
      log("init error: $e\n$st");
      if (!mounted) return;
      setState(() => errorText = e.toString());
    }
  }

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

  void _showPrizeDialog(
    int rid,
    String number,
    String prizeName,
    String amount,
  ) {
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
            onPressed: () async {
              await getmoney(rid);
              if (!mounted) return;
              Navigator.pop(context); // ปิด dialog
              await getrewards(); // โหลดรางวัลใหม่ (แล้ว _recomputeWins() จะถูกเรียก)
            },
            child: const Text("ขึ้นเงิน"),
          ),
        ],
      ),
    );
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
                            number: rewardJackpot?.lottoNumber,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ticketCard(
                              'Second Prize',
                              number: rewardSecond?.lottoNumber,
                            ),
                            _ticketCard(
                              'Third Prize',
                              number: rewardThird?.lottoNumber,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ticketCard(
                              'Last 3 Numbers',
                              number: _lastNDigits(rewardLast3?.lottoNumber, 3),
                            ),
                            _ticketCard(
                              'Last 2 Numbers',
                              number: _lastNDigits(rewardLast2?.lottoNumber, 2),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        if (hasWin) ...[
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
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: myWinningRewards.map((rw) {
                              final displayNumber = (rw.rewardRank == 4)
                                  ? (_lastNDigits(rw.lottoNumber, 3) ?? '')
                                  : (rw.rewardRank == 5)
                                  ? (_lastNDigits(rw.lottoNumber, 2) ?? '')
                                  : rw.lottoNumber;
                              return _ticketCard(
                                _prizeName(rw.rewardRank),
                                number: displayNumber,
                                onTap: () => _showPrizeDialog(
                                  rw.rid,
                                  displayNumber,
                                  _prizeName(rw.rewardRank),
                                  rw.prizeAmount,
                                ),
                              );
                            }).toList(),
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

  String _prizeName(int rank) {
    switch (rank) {
      case 1:
        return 'Jackpot';
      case 2:
        return 'Second Prize';
      case 3:
        return 'Third Prize';
      case 4:
        return 'Last 3 Numbers';
      case 5:
        return 'Last 2 Numbers';
      default:
        return 'Prize';
    }
  }

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
      _recomputeWins();
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
      final uri = Uri.parse("$url/lottery/rawards");
      final res = await http.get(
        uri,
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );
      if (res.statusCode != 200) {
        throw Exception("HTTP ${res.statusCode}: ${res.body}");
      }
      var decoded = rewardGetResponseFromJson(res.body);

      setState(() {
        rewards = decoded;

        final byRank = <int, RewardGetResponse>{};
        for (final r in decoded) {
          byRank[r.rewardRank] = r;
        }

        rewardJackpot = byRank[1];
        rewardSecond = byRank[2];
        rewardThird = byRank[3];
        rewardLast3 = byRank[4];
        rewardLast2 = byRank[5];
      });
      _recomputeWins();
    } catch (e, st) {
      log("reward error: $e\n$st");
      if (!mounted) return;
      setState(() => errorText = e.toString());
    } finally {
      EasyLoading.dismiss();
      if (mounted) setState(() => loading = false);
    }
  }

  String? _lastNDigits(String? s, int n) {
    if (s == null) return null;
    final t = s.trim();
    if (t.isEmpty) return null;

    if (t.length <= n) return t;
    return t.substring(t.length - n);
  }

  void _recomputeWins() {
    final myLids = lottos.map((e) => e.lid).toSet();

    // แสดงเฉพาะรางวัลของเรา + ยังไม่ขึ้นเงิน (status == 0)
    final wins = rewards
        .where((r) => myLids.contains(r.lid) && (r.claimStatus == 0))
        .toList();

    setState(() {
      myWinningRewards = wins;
    });
  }

  Future<void> getmoney(int rid) async {
    log(rid.toString());
    final uri = Uri.parse("$url/lottery/rawards/claim/$rid");
    final response = await http.put(
      uri,
      headers: {"Content-Type": "application/json; charset=utf-8"},
    );

    final Map<String, dynamic> res = jsonDecode(response.body);

    if (!mounted) return;

    if (res['message'] != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res['message'])));
    }
  }
}
