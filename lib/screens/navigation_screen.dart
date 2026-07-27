import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'log_screen.dart';
import 'settings_screen.dart';
import '../widgets/bottom_nav.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  static void changeTab(
      BuildContext context,
      int index,
  ) {

    final state =
        context.findAncestorStateOfType<
            _NavigationScreenState>();

    state?.changePage(index);

  }


  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    LogScreen(),
    SettingsScreen(),
  ];

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onTap: changePage,
      ),
    );
  }
}