import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final int currentIndex;
  final Function(int) onNavigationTap;
  final List<Widget>? actions;

  const BaseLayout({
    super.key,
    required this.title,
    required this.body,
    required this.currentIndex,
    required this.onNavigationTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
        centerTitle: true,
      ),

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