import 'package:flutter/material.dart';

class ADProfilePage extends StatefulWidget {
  const ADProfilePage({super.key});

  @override
  State<ADProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ADProfilePage> {
  int _navIndex = 2;

  void _onNavTap(int i) {
    if (i == _navIndex) return;
    setState(() => _navIndex = i);
    switch (i) {
      case 0:
        Navigator.pushReplacementNamed(context, '/adhome_login');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/adlucky');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/adprofile');
        break;
    }
  }

  Widget _roundedAction({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.black87),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ซ่อน back อัตโนมัติ; เราทำปุ่มเอง
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/images/Backgroud.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Title + Back
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 26),
                      color: Colors.black87,
                      splashRadius: 22,
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.pushReplacementNamed(
                            context,
                            '/adhome_login',
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ปุ่ม/ฟิลด์ตามภาพ
                _roundedAction(
                  icon: Icons.person_outline,
                  text: 'Profile',
                  onTap: () {
                    // TODO: ไปหน้าแก้ไขโปรไฟล์หรือดูข้อมูลผู้ใช้
                  },
                ),
                const SizedBox(height: 12),
                _roundedAction(
                  icon: Icons.logout,
                  text: 'Logout',
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  },
                ),

                const Spacer(flex: 20),

                // ปุ่มสีแดง
                Center(
                  child: SizedBox(
                    width: 130,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: ใส่ logic ถ้าต้องการ
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Clear Data'),
                    ),
                  ),
                ),
                const Spacer(),
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
            currentIndex: _navIndex,
            onTap: _onNavTap,
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
