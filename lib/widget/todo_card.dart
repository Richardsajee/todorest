import 'package:flutter/material.dart';

class Todo_card extends StatelessWidget {
  const Todo_card(
      {super.key,
      required this.index,
      required this.item,
      required this.naviagetEdit,
      required this.deleteByid});
  final int index;
  final Map item;
  final Function(Map) naviagetEdit;
  final Function(String) deleteByid;

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Card(
      child: ListTile(
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'edit') {
              naviagetEdit(item);
            } else if (value == 'delete') {
              deleteByid(id);
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text('Edit'),
                value: 'edit',
              ),
              PopupMenuItem(
                child: Text('Delete'),
                value: 'delete',
              )
            ];
          },
        ),
      ),
    );
  }
}
