import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodoPage extends StatefulWidget {
  final String selectedFilter;

  const TodoPage({Key? key, required this.selectedFilter}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<dynamic> todoList = [];
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              // physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: todoList.length,
              separatorBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    color: Colors.white,
                  ),
                );
              },
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: isCheckedList[index],
                    onChanged: (value) {
                      setState(() {
                        isCheckedList[index] = value ?? false;
                      });
                    },
                  ),
                  title: Text(
                    todoList[index]['title'],
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  subtitle: Text(
                    "User Id: ${todoList[index]['userId']}",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                );
              },
            ),
    );
  }
}
