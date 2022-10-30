// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moni/db/nodes_databse.dart';
import 'package:moni/model/node.dart';
import 'package:moni/widgets/accountant_body.dart';

class Accountant extends StatefulWidget {
  const Accountant({super.key});

  @override
  State<Accountant> createState() => _AccountantState();
}

class _AccountantState extends State<Accountant> {
  late NodesDatabase nodeDB;
  late List<Node> NODES;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nodeDB = NodesDatabase.instance;

    refreshNodes();
  }

  Future refreshNodes() async {
    setState(() => isLoading = true);

    NODES = await NodesDatabase.instance.readAllNodes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // DB Interaction

    var nodeDB = NodesDatabase.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accountant'),
        backgroundColor: Colors.black54,
        actions: [
          IconButton(onPressed: createNode, icon: const Icon(Icons.add))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : AccountantBody(NODES: NODES),
    );
  }

  void createNode() {
    print('HI NODE');

    // nodeDB.create(
    //   Node(
    //       name: 'name',
    //       bg_color: 'bg_color',
    //       txt_color: 'txt_color',
    //       size: 1,
    //       max_amt: 1500,
    //       present_amt: 50),
    // );

    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return Dialog(
    //       child: Column(children: const [
    //         TextField(
    //           decoration: InputDecoration(hintText: 'Name'),
    //         )
    //       ]),
    //     );
    //   },
    // );
  }
}
