import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int completed = 0;
  List<dynamic> todoList = [];
  bool conn = true;

  int incompleted = 0;
  bool _isLoading = true;
  late List<bool> isCheckedList;

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
        for (var todo in todoList) {
          if (todo['completed'] == true) {
            completed++;
          } else {
            incompleted++;
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
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.cyan.shade50),
                  child: Text(
                    "Completed Todo : $completed",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.amber.shade50),
                  child: Text(
                    "In-Completed Todo : $incompleted",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          );
  }
}
