import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todorest/screens/add_page.dart';
import 'package:http/http.dart' as http;
import 'package:todorest/services/todo_service.dart';
import 'package:todorest/widget/todo_card.dart';

class To_do_list_Page extends StatefulWidget {
  const To_do_list_Page({super.key});

  @override
  State<To_do_list_Page> createState() => _To_do_list_PageState();
}

class _To_do_list_PageState extends State<To_do_list_Page> {
  bool isloading = true;
  List items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(94, 62, 60, 60),
        title: Center(
            child: Text(
          'Todo List',
        )),
      ),
      body: Visibility(
        visible: isloading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return Todo_card(
                    index: index,
                    item: item,
                    naviagetEdit: naviagatetoeditpage,
                    deleteByid: deleteByid);
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: naviagatetoaddpage, label: Text('Add todo')),
    );
  }

  Future<void> naviagatetoeditpage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => Add_todo_page(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchTodo();
  }

  Future<void> naviagatetoaddpage() async {
    final route = MaterialPageRoute(
      builder: (context) => Add_todo_page(),
    );
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchTodo();
  }

  Future<void> deleteByid(String id) async {
    final issuccess = await TodoService.deleteByid(id);

    if (issuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodo();
    if (response != null) {
      setState(() {
        items = response;
      });
    }
    setState(() {
      isloading = false;
    });
  }
}
