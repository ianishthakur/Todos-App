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
  // Initial Selected Value
  String dropdownvalue = 'Show All';

  // List of items in our dropdown menu
  var items = [
    'Show All',
    'Show Active',
    'Show Completed',
  ];
  List _pages = [
    TodoPage(
        selectedFilter:
            'Show All'), // Initialize TodoPage with default filter value
    StatsPage(),
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
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.grey.shade800,
        title: const Text(
          "Flutter Todos",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              elevation: 0,
              dropdownColor: Colors.grey.shade800,
              iconDisabledColor: Colors.white,
              iconEnabledColor: Colors.white,
              icon: const Icon(Icons.more_horiz_outlined,
                  color: Colors.white, size: 26),
              items: items.map((String item) {
                bool isSelected = item == dropdownvalue;
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: isSelected ? Colors.cyan : Colors.white,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                  // Update the TodoPage with the new filter value
                  _pages[0] = TodoPage(selectedFilter: dropdownvalue);
                });
              },
              value: dropdownvalue,
            ),
          ),
        ],
      ),
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
