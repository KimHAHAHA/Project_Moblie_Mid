import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_app/pages/Admin/ad_admin.dart';
import 'package:my_app/pages/Admin/ad_home_login.dart';

class ADLuckyPage extends StatefulWidget {
  final int idx;
  const ADLuckyPage({super.key, required this.idx});

  @override
  State<ADLuckyPage> createState() => _HomePageState();
}

class _HomePageState extends State<ADLuckyPage> {
  // ช่องกรอก PIN 6 หลัก
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  int _selectedIndex = 1;

  // ===== เมนูเลือกประเภทการสุ่ม (ตัด "ยังไม่ถูกซื้อ" ออก) =====
  String _drawType = 'all'; // ค่าเริ่มต้น
  final Map<String, String> _drawTypeItems = const {
    'bought': 'Lottery ที่ถูกซื้อแล้ว',
    'all': 'Lottery ทั้งหมด',
  };

  // ===== เลขบนการ์ด 5 ใบ + ตัวชี้ใบถัดไป =====
  final List<String?> _cardNumbers = List<String?>.filled(5, null);
  int _nextCardIndex = 0; // 0..4

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  // สุ่ม PIN 6 หลักลงช่องอินพุต
  void _randomFill() {
    final r = Random();
    for (int i = 0; i < 6; i++) {
      _controllers[i].text = r.nextInt(10).toString();
    }
    setState(() {});
  }

  // รวมค่าจาก 6 ช่องเป็นสตริง 6 หลัก (ช่องว่างแทนด้วย 0)
  String _composePin() {
    final b = StringBuffer();
    for (final c in _controllers) {
      final t = (c.text.trim().isEmpty) ? '0' : c.text.trim();
      b.write(t[0]);
    }
    return b.toString();
  }

  // กด Random:
  // 1) สุ่มเลขใหม่ทุกครั้ง
  // 2) รวมเป็นเลข 6 หลัก
  // 3) เติมลง "การ์ดใบถัดไป" ทีละใบจนถึงใบที่ 5
  void _randomToCard() {
    _randomFill(); // ✅ สุ่มเลขใหม่เสมอ
    final number = _composePin();

    if (_nextCardIndex < 5) {
      setState(() {
        _cardNumbers[_nextCardIndex] = number;
        _nextCardIndex++;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('การ์ดครบ 5 ใบแล้ว')));
    }
  }

  // ===== PIN box =====
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

  // ปุ่มเข้ม
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

  // การ์ดรางวัล
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

  // Bottom nav
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
                // หัวข้อ + back
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

                // เมนูเลือกประเภท + ปุ่ม Random
                _filterRow(),
                const SizedBox(height: 16),

                // การ์ดรางวัล
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
                              number: _cardNumbers[3],
                            ),
                            _ticketCard(
                              'Last 2 Numbers',
                              number: _cardNumbers[4],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                Center(child: _darkButton('Confirm', () {})),
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
}
