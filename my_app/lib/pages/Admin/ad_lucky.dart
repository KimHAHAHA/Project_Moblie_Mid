import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/config/config.dart';
import 'package:my_app/model/response/lotto_get_res.dart';
import 'package:my_app/model/response/rewards_get_res.dart';
import 'package:my_app/pages/Admin/ad_admin.dart';
import 'package:my_app/pages/Admin/ad_home_login.dart';

class ADLuckyPage extends StatefulWidget {
  final int idx;
  const ADLuckyPage({super.key, required this.idx});

  @override
  State<ADLuckyPage> createState() => _HomePageState();
}

class _HomePageState extends State<ADLuckyPage> {
  List<LottosGetResponse> lottoall = [];
  List<LottosGetResponse> lottosold = [];
  List<RewardGetResponse> rewards = [];
  RewardGetResponse? rewardJackpot,
      rewardSecond,
      rewardThird,
      rewardLast3,
      rewardLast2;

  String url = "";
  String errorText = "";
  bool loading = false;
  int _selectedIndex = 1;
  final Set<int> _usedLids = {};

  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final config = await Configuration.getConfig();
      url = (config["apiEndpoint"] as String).trim();
      await _fetchLottoData();
      await getrewards();
    } catch (e, st) {
      log("init error: $e\n$st");
      if (!mounted) return;
      setState(() => errorText = e.toString());
    }
  }

  String _drawType = 'all';
  final Map<String, String> _drawTypeItems = const {
    'sold': 'Lottery ที่ถูกซื้อแล้ว',
    'all': 'Lottery ทั้งหมด',
  };

  final List<String?> _cardNumbers = List<String?>.filled(5, null);
  int _nextCardIndex = 0;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
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

  Widget _pinContainer() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: Border.all(color: Colors.black26, width: 1.6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

  Widget _filterRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'เลือกประเภทการสุ่ม',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _drawType,
                items: _drawTypeItems.entries
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e.key, child: Text(e.value)),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _drawType = v);
                },
                decoration: InputDecoration(
                  isDense: true,
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
            ),
            const SizedBox(width: 10),
            SizedBox(height: 42, child: _darkButton('Random', _randomToCard)),
          ],
        ),
      ],
    );
  }

  Widget _ticketCard(
    String title, {
    String? number,
    bool isCenterTitle = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: isCenterTitle ? Alignment.center : Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 80,
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: AssetImage('assets/images/Cupong.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              if (number != null)
                Positioned(
                  top: 28,
                  left: 60,
                  child: Center(
                    child: Text(
                      number,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
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
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Lucky Numbers',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ADHome_LoginPage(idx: widget.idx),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                _pinContainer(),
                const SizedBox(height: 12),

                _filterRow(),
                const SizedBox(height: 16),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: _ticketCard(
                            'Jackpot',
                            isCenterTitle: true,
                            number: _cardNumbers[0],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ticketCard(
                              'Second Prize',
                              number: _cardNumbers[1],
                            ),
                            _ticketCard('Third Prize', number: _cardNumbers[2]),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ticketCard(
                              'Last 3 Numbers',
                              number: _tail(_cardNumbers[3], 3),
                            ),
                            _ticketCard(
                              'Last 2 Numbers',
                              number: _tail(_cardNumbers[4], 2),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
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
                icon: Icon(Icons.card_giftcard),
                label: 'Lucky Numbers',
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

      var decoded = lottosGetResponseFromJson(res.body);

      if (!mounted) return;
      setState(() {
        lottoall = decoded;
        lottosold = decoded
            .where((item) => item.lottoStatus == "sold")
            .toList();
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

  LottosGetResponse RandomLottoUnique() {
    final random = Random();

    final source = _drawType == "all" ? lottoall : lottosold;
    final available = source.where((e) => !_usedLids.contains(e.lid)).toList();

    if (available.isEmpty) {
      throw Exception("ไม่พบล็อตเตอรี่สำหรับการสุ่ม (เหลือแต่ตัวที่ใช้ไปแล้ว)");
    }

    final index = random.nextInt(available.length);
    final picked = available[index];

    _usedLids.add(picked.lid);
    return picked;
  }

  void setLottoNumberToControllers(LottosGetResponse lotto) {
    final number = lotto.lottoNumber.padLeft(6, '0');
    for (int i = 0; i < 6; i++) {
      _controllers[i].text = number[i];
    }
    setState(() {});
  }

  void _randomToCard() {
    try {
      final randomLotto = RandomLottoUnique();

      setLottoNumberToControllers(randomLotto);

      if (_nextCardIndex < 5) {
        setState(() {
          if (_nextCardIndex == 0) {
            _cardNumbers[_nextCardIndex] = randomLotto.lottoNumber;
            _cardNumbers[3] = randomLotto.lottoNumber;

            Reward(randomLotto.lid, _nextCardIndex + 1);
            Reward(randomLotto.lid, _nextCardIndex + 4);
          } else if (_nextCardIndex != 3) {
            _cardNumbers[_nextCardIndex] = randomLotto.lottoNumber;
            Reward(randomLotto.lid, _nextCardIndex + 1);
          }

          _nextCardIndex++;

          if (_nextCardIndex == 3) {
            _nextCardIndex++;
          }
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('การ์ดครบ 5 ใบแล้ว')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> Reward(int lid, int rank) async {
    try {
      var body = jsonEncode({"lid": lid, "reward_rank": rank});

      await http.post(
        Uri.parse("$url/lottery/rewards"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: body,
      );
    } catch (e) {
      log("Reward error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ส่งข้อมูลไม่สำเร็จ')));
    }
  }

  String? _tail(String? num, int n) {
    if (num == null) return null;
    final s = num.padLeft(6, '0'); // เผื่อกรณีมี 0 นำหน้า
    return s.substring(s.length - n);
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

      final decoded = rewardGetResponseFromJson(res.body);
      log(decoded.toString());

      if (!mounted) return;
      setState(() {
        rewards = decoded;

        // จัดรางวัลตาม rank
        final byRank = <int, RewardGetResponse>{};
        for (final r in decoded) {
          byRank[r.rewardRank] = r; // ถ้ามีซ้ำ rank เดียวกัน จะใช้ตัวท้ายสุด
        }

        rewardJackpot = byRank[1];
        rewardSecond = byRank[2];
        rewardThird = byRank[3];
        rewardLast3 = byRank[4];
        rewardLast2 = byRank[5];

        // เติมค่าลงการ์ด (เก็บ "เลขเต็ม 6 หลัก" ไว้ก่อน ค่อยไปตัดท้ายตอนแสดง)
        _cardNumbers[0] = rewardJackpot?.lottoNumber;
        _cardNumbers[1] = rewardSecond?.lottoNumber;
        _cardNumbers[2] = rewardThird?.lottoNumber;
        _cardNumbers[3] = rewardLast3?.lottoNumber;
        _cardNumbers[4] = rewardLast2?.lottoNumber;

        // กันสุ่มซ้ำ: มาร์ค lid ที่ใช้งานไปแล้ว
        _usedLids.clear();
        for (final r in [
          rewardJackpot,
          rewardSecond,
          rewardThird,
          rewardLast3,
          rewardLast2,
        ]) {
          final lid = r?.lid;
          if (lid != null) _usedLids.add(lid);
        }

        // กำหนด index ต่อไปที่จะสุ่มลงการ์ด (ข้าม index 3 ตามลอจิกเดิมของ _randomToCard)
        int next = 0;
        while (next < 5 && _cardNumbers[next] != null) {
          next++;
          if (next == 3) next++; // ข้าม "Last 3 Numbers" ตาม flow เดิม
        }
        _nextCardIndex = next >= 5 ? 5 : next;
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
