// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moni/db/nodes_databse.dart';
import 'package:moni/model/node.dart';
import 'package:moni/utils/controllers.dart';
import 'package:moni/utils/methods.dart';
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
    // nodeDB.create(
    //   Node(
    //       name: 'name',
    //       bg_color: 'bg_color',
    //       txt_color: 'txt_color',
    //       size: 1,
    //       max_amt: 1500,
    //       present_amt: 50),
    // );

    Color nodeBackgroundColor = Colors.black;
    Color nodeTextColor = Colors.blue;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        //
        void changeBGColor(Color bgcolor) {
          setState(() {
            nodeBackgroundColor = bgcolor;
          });
        }

        void changeTXTColor(Color txtcolor) {
          setState(() {
            nodeTextColor = txtcolor;
          });
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create Node...',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(label: Text('Name')),
                    controller: node_inputcontroller__NAME,
                  ),
                  ListTile(
                    contentPadding:
                        EdgeInsets.only(left: 0, right: 8, top: 8, bottom: 8),
                    title: Text('Background Color'),
                    trailing: ElevatedButton(
                      onPressed: (() {
                        // BG COLOR

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ColorPicker(
                                    pickerColor: nodeBackgroundColor,
                                    onColorChanged: (value) =>
                                        changeBGColor(value),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: (() {
                                      setState(() {
                                        Navigator.of(context).pop();
                                      });
                                    }),
                                    child: Text('OK'))
                              ],
                            );
                          },
                        );
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: nodeBackgroundColor,
                      ),
                      child: const Icon(Icons.color_lens),
                    ),
                  ),
                  ListTile(
                    contentPadding:
                        EdgeInsets.only(left: 0, right: 8, top: 0, bottom: 8),
                    title: Text('Text Color'),
                    trailing: ElevatedButton(
                      onPressed: (() {
                        // TEXT COLOR

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ColorPicker(
                                    pickerColor: nodeTextColor,
                                    onColorChanged: (value) =>
                                        changeTXTColor(value),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: (() {
                                      setState(() {
                                        Navigator.of(context).pop();
                                      });
                                    }),
                                    child: Text('OK'))
                              ],
                            );
                          },
                        );
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: nodeTextColor,
                      ),
                      child: const Icon(Icons.color_lens),
                    ),
                  ),
                  TextField(
                    controller: node_inputcontroller__TARGET_AMT,
                    decoration: InputDecoration(label: Text('Target Amt.')),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      // GET THE VALUES:
                      final name = node_inputcontroller__NAME.text;
                      final maxAmt = node_inputcontroller__TARGET_AMT.text;
                      final bgColor = nodeBackgroundColor;
                      final textColor = nodeTextColor;

                      // FRISK
                      if (name.isEmpty) {
                        showSnackBarMSG(context, 'Name is empty!');
                        return;
                      }
                      if (maxAmt.isEmpty) {
                        showSnackBarMSG(context, 'Max Amount is empty!');
                        return;
                      }

                      // ADD 2 DB

                      nodeDB.create(
                        Node(
                            name: name,
                            bg_color: '#${colorToHex(bgColor)}',
                            txt_color: '#${colorToHex(textColor)}',
                            size: 1,
                            max_amt: int.parse(maxAmt),
                            present_amt: 0),
                      );

                      setState(
                        () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    child: const Text('CREATE')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      node_inputcontroller__NAME.text = '';
                      node_inputcontroller__TARGET_AMT.text = '';
                    },
                    child: const Text('CANCEL')),
              ],
            );
          },
        );
      },
    );
  }
}
