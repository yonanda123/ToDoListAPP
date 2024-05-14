import 'package:flutter/material.dart';
import 'package:to_do_list_app/pages/dashboard.dart';
import 'package:to_do_list_app/pages/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const Dashboard(),
    const Profile(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: Container(
        width: 56.0,
        height: 56.0,
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: const Color(0xFFF14A5B),
          shape: const CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomAppBar(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 60,
          color: const Color(0xFFB19CEC),
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () => _onTabTapped(0),
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
                onPressed: () => _onTabTapped(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
