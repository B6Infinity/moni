import 'package:flutter/material.dart';

void showSnackBarMSG(var context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
