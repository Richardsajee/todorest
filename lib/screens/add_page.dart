import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todorest/services/todo_service.dart';
import 'package:todorest/utils/snackbar.dart';

class Add_todo_page extends StatefulWidget {
  const Add_todo_page({super.key, this.todo});
  final Map? todo;

  @override
  State<Add_todo_page> createState() => _Add_todo_pageState();
}

class _Add_todo_pageState extends State<Add_todo_page> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titlecontroller.text = title;
      descriptioncontroller.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit todo' : 'Add todo'),
      ),
      body: ListView(
        children: [
          TextField(
            decoration: InputDecoration(hintText: 'Title'),
            controller: titlecontroller,
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
              decoration: InputDecoration(hintText: 'Desccription'),
              controller: descriptioncontroller),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: isEdit ? Updatedata : sumbmitdata,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(isEdit ? 'Update' : 'Sumbit'),
              ))
        ],
      ),
    );
  }

  Future<void> Updatedata() async {
    final todo = widget.todo;
    if (todo == null) {
      print('you can not call update without todo data');
      return;
    }
    final id = todo['_id'];
    // final iscompleted=todo['is completed'];
    final title = titlecontroller.text;
    final description = descriptioncontroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    final issuccess = await TodoService.Updatedata(id, body);

    if (issuccess) {
      // print('Creation Success ');
      Showsuccesmessage(context, message: 'Updation Success');
    } else {
      // print('Creation Failed');

      Showsuccesmessage(context, message: 'Updation Failed');
    }
  }

  Future<void> sumbmitdata() async {
    final title = titlecontroller.text;
    final description = descriptioncontroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      titlecontroller.text = '';
      descriptioncontroller.text = '';
      print('Creation Success ');
      Showsuccesmessage(context, message: 'Creation Success');
    } else {
      print('Creation Failed');
      print(response.body);
      Showsuccesmessage(context, message: 'Creation Failed');
    }
  }
}
