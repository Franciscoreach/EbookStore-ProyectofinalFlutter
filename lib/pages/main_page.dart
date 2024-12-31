
import 'package:flutter/material.dart';
import 'package:proyectofinal/pages/bookmark_page.dart';
import 'package:proyectofinal/pages/home_page.dart';
import 'package:proyectofinal/pages/reading_page.dart';
import 'package:proyectofinal/widgets/app_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ReadingPage(),
    BookmarkPage(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 80,
        color: AppColor.white,
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _itemBottomMenu(
              onTap: () => onItemTapped(0),
              isActive: selectedIndex == 0,
              title: "Explore",
              icon: Icons.explore_outlined,
            ),
            _itemBottomMenu(
              onTap: () => onItemTapped(1),
              isActive: selectedIndex == 1,
              title: "Reading",
              icon: Icons.book_rounded,
            ),
            _itemBottomMenu(
              onTap: () => onItemTapped(2),
              isActive: selectedIndex == 2,
              title: "Bookmark",
              icon: Icons.bookmark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemBottomMenu({
    required Function() onTap,
    required bool isActive,
    required String title,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Icon(
                icon,
                color: isActive ? AppColor.orange : AppColor.black,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
