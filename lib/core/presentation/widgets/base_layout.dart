import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  final String? title; // Make title optional
  final Widget body;
  final int currentIndex;
  final Function(int) onNavigationTap;
  final List<Widget>? actions;
  final bool showAppBar; // Add this parameter

  const BaseLayout({
    super.key,
    this.title, // Optional now
    required this.body,
    required this.currentIndex,
    required this.onNavigationTap,
    this.actions,
    this.showAppBar = true, // Default to true
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar && title != null // Conditionally show AppBar
          ? AppBar(
              title: Text(title!),
              actions: actions,
              centerTitle: true,
            )
          : null,

      body: body,

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          key: const Key('bottom_nav_bar'),
          currentIndex: currentIndex,
          onTap: onNavigationTap,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: '',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.money_off),
              label: '',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}