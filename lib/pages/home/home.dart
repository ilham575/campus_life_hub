import 'package:campus_life_hub/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_life_hub/pages/profile/profile.dart'; // Assuming profile_page.dart exists

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Define the _logout widget as a method that takes context
  Widget _logout(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0D6EFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: () async {
        await AuthService().signout(context: context);
      },
      child: const Text(
        "Sign Out",
        style: TextStyle(
          color: Colors.white, // เปลี่ยนเป็นสีที่ต้องการ เช่น Colors.blue
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define the _pages list inside the build method
    // This ensures that 'context' is available when creating these widgets.
    final List<Widget> _pages = [
      // This is the content for the "Home" tab
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello👋',
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                FirebaseAuth.instance.currentUser!.email!.toString(),
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // เพิ่ม Card ข่าว
              NewsCardList(),
              const SizedBox(height: 30),
              _logout(context),
            ],
          ),
        ),
      ),
      ProfilePage(), // Your Profile Page
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าแรก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'โปรไฟล์',
          ),
        ],
      ),
    );
  }
}

// เพิ่ม Widget สำหรับแสดงข่าว
class NewsCardList extends StatefulWidget {
  const NewsCardList({super.key});

  @override
  State<NewsCardList> createState() => _NewsCardListState();
}

class _NewsCardListState extends State<NewsCardList> {
  final List<Map<String, dynamic>> newsList = [
    {
      'title': 'กิจกรรมรับน้องใหม่',
      'detail': 'ขอเชิญนักศึกษาใหม่เข้าร่วมกิจกรรมรับน้อง วันที่ 10 มิ.ย. 2567',
      'category': 'กิจกรรม',
      'source': 'คณะวิศวกรรมศาสตร์',
      'isSaved': false,
    },
    {
      'title': 'ประกาศปิดปรับปรุงระบบ',
      'detail': 'ระบบจะปิดปรับปรุงในวันที่ 15 มิ.ย. 2567 เวลา 22:00-02:00 น.',
      'category': 'ทั่วไป',
      'source': 'มหาวิทยาลัย',
      'isSaved': false,
    },
    {
      'title': 'ทุนการศึกษาประจำปี',
      'detail': 'เปิดรับสมัครทุนการศึกษาสำหรับนักศึกษาที่มีผลการเรียนดี',
      'category': 'วิชาการ',
      'source': 'กองกิจการนักศึกษา',
      'isSaved': false,
    },
  ];

  String selectedCategory = 'ทั้งหมด';

  List<String> get categories {
    final cats = newsList.map((e) => e['category'] as String).toSet().toList();
    cats.sort();
    return ['ทั้งหมด', ...cats];
  }

  void _toggleSave(int idx) {
    setState(() {
      newsList[idx]['isSaved'] = !(newsList[idx]['isSaved'] as bool);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredNews = selectedCategory == 'ทั้งหมด'
        ? newsList
        : newsList.where((news) => news['category'] == selectedCategory).toList();

    return Column(
      children: [
        Row(
          children: [
            const Text('หมวดหมู่:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: selectedCategory,
              items: categories
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value ?? 'ทั้งหมด';
                });
              },
            ),
          ],
        ),
        ...filteredNews.asMap().entries.map((entry) {
          final idx = entry.key;
          final news = entry.value;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ExpansionTile(
              leading: const Icon(Icons.campaign, color: Colors.deepPurple),
              title: Row(
                children: [
                  Expanded(
                    child: Text(news['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      news['category'] ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ],
              ),
              subtitle: Text(news['source'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(news['detail'] ?? ''),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        news['isSaved'] ? Icons.bookmark : Icons.bookmark_border,
                        color: news['isSaved'] ? Colors.orange : Colors.grey,
                      ),
                      onPressed: () => _toggleSave(idx),
                      tooltip: news['isSaved'] ? 'ยกเลิกบันทึก' : 'บันทึกประกาศ',
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}