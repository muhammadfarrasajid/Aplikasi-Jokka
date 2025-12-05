import 'package:flutter/material.dart';

import '../../home/home_page.dart';
import '../../explore/presentation/explore_page.dart';
import '../../articles/presentation/articles_page.dart';
import '../../wishlist/presentation/wishlist_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _pages = [
    const HomePage(),
    const ExplorePage(),
    const ArticlesPage(),
    const WishlistPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _pages[_currentIndex]),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_outlined,
                      isActive: _currentIndex == 0,
                      onTap: () => _onTabTapped(0),
                    ),
                    _NavItem(
                      icon: Icons.explore_outlined,
                      isActive: _currentIndex == 1,
                      onTap: () => _onTabTapped(1),
                    ),
                    _NavItem(
                      icon: Icons.article_outlined,
                      isActive: _currentIndex == 2,
                      onTap: () => _onTabTapped(2),
                    ),
                    _NavItem(
                      icon: Icons.bookmark_border,
                      isActive: _currentIndex == 3,
                      onTap: () => _onTabTapped(3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
    });
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 24,
          color: isActive ? Colors.white : Colors.white70,
        ),
      ),
    );
  }
}
