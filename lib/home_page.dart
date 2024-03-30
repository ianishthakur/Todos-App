import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app/stats_page.dart';
import 'package:todo_app/todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List _pages = [
    const TodoPage(), // Initialize TodoPage with default filter value
    const StatsPage(),
  ];
  int _currentPage = 0;

  _onPageSwitch(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        onTap: (index) => _onPageSwitch(index),
        currentIndex: _currentPage,
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.menu,
              ),
              label: "Todos"),
          BottomNavigationBarItem(
              icon: Icon(Icons.turn_sharp_right_outlined), label: "Stats")
        ],
      ),
      body: _pages[_currentPage],
    );
  }
}
