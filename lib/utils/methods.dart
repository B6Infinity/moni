import 'package:flutter/material.dart';

void showSnackBarMSG(var context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

// Color colorFromHex(String hexColor) {
//   final hexCode = hexColor.replaceAll('#', '');
//   return Color(int.parse('FF$hexCode', radix: 16));
// }
