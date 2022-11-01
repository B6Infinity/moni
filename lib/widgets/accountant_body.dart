// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:moni/model/node.dart';

class AccountantBody extends StatefulWidget {
  const AccountantBody({super.key, required this.NODES});

  @override
  State<AccountantBody> createState() => _AccountantBodyState();

  final List<Node> NODES;
}

class _AccountantBodyState extends State<AccountantBody> {
  @override
  Widget build(BuildContext context) {
    for (var node in widget.NODES) {
      print(node.toJson());
    }

    // SHOW THE NODES

    return const Text('data:');
  }
}
