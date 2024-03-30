import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodoPage extends StatefulWidget {
  const TodoPage({
    super.key,
  });

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<dynamic> todoList = [];
  List<dynamic> activeList = [];
  List<dynamic> completeList = [];
  bool _isLoading = true;

  late List<bool> isCheckedList;
  String dropdownvalue = 'Show All';

  var items = [
    'Show All',
    'Show Active',
    'Show Completed',
  ];

  @override
  void initState() {
    isCheckedList = [];
    _fetchData();
    super.initState();
  }

  _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse("https://jsonplaceholder.typicode.com/todos"),
      );
      if (response.statusCode == 200) {
        todoList = jsonDecode(response.body);
        isCheckedList = List<bool>.filled(todoList.length, false);
        for (var completed in todoList) {
          if (completed['completed'] == true) {
            completeList.add(completed);
          }
        }
        setState(() {
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error fetching posts: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
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
                });
              },
              value: dropdownvalue,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              shrinkWrap: true,
              itemCount: items[0] == dropdownvalue
                  ? todoList.length
                  : items[1] == dropdownvalue
                      ? activeList.length
                      : completeList.length,
              separatorBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    color: Colors.white,
                  ),
                );
              },
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(items[0] == dropdownvalue
                      ? todoList[index]['id'].toString()
                      : items[1] == dropdownvalue
                          ? activeList[index]['id'].toString()
                          : completeList[index]['id'].toString()),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd ||
                        direction == DismissDirection.endToStart) {
                      setState(() {
                        items[0] == dropdownvalue
                            ? todoList.removeAt(index)
                            : items[1] == dropdownvalue
                                ? activeList.removeAt(index)
                                : completeList.removeAt(index);
                      });
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: isCheckedList[index],
                      onChanged: (value) {
                        setState(() {
                          isCheckedList[index] = value ?? false;
                          activeList.add(todoList[index]);
                        });
                      },
                    ),
                    title: Text(
                      items[0] == dropdownvalue
                          ? todoList[index]['title']
                          : items[1] == dropdownvalue
                              ? activeList[index]["title"]
                              : completeList[index]["title"],
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    subtitle: Text(
                      items[0] == dropdownvalue
                          ? "User Id: ${todoList[index]['userId']}"
                          : items[1] == dropdownvalue
                              ? "User Id: ${activeList[index]['userId']}"
                              : "User Id: ${completeList[index]['userId']}",
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
