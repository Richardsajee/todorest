import 'package:flutter/material.dart';

void Showsuccesmessage(BuildContext context, {required String message}) {
  final snackbar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
