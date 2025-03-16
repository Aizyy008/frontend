import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:user_subscription_management/screens/profile_screen.dart';
import 'package:user_subscription_management/screens/subscriptions_screen.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _bottomNavIndex = 0; // Default screen index

  final List<Widget> _screens = [
    ProfileScreen(key: PageStorageKey('ProfileScreen')),
    SubscriptionsScreen(key: PageStorageKey('SubscriptionsScreen')),
  ];

  final iconList = <IconData>[
    Icons.person, // Profile Icon
    Icons.subscriptions, // Subscription Icon
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _bottomNavIndex,
        children: _screens,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Colors.blue : Colors.grey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconList[index], size: 24, color: color),
              SizedBox(height: 4),
              Text(
                index == 0 ? "Profile" : "Subscription",
                style: TextStyle(color: color),
              ),
            ],
          );
        },
        backgroundColor: Colors.white,
        activeIndex: _bottomNavIndex,
        splashColor: Colors.blue,
        notchSmoothness: NotchSmoothness.smoothEdge, // Removes center notch
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        gapLocation: GapLocation.none, // Removes space for FAB
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
