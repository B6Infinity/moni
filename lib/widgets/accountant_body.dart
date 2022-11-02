// ignore_for_file: non_constant_identifier_names

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:moni/model/node.dart';
import 'package:moni/utils/controllers.dart';

class AccountantBody extends StatefulWidget {
  const AccountantBody({super.key, required this.NODES});

  @override
  State<AccountantBody> createState() => _AccountantBodyState();

  final List<Node> NODES;
}

class _AccountantBodyState extends State<AccountantBody> {
  @override
  Widget build(BuildContext context) {
    List<Widget> nodeCards = [];

    for (var node in widget.NODES) {
      print(node.toJson());

      nodeCards.add(
        StaggeredGridTile.count(
          crossAxisCellCount: node.size,
          mainAxisCellCount: node.size,
          child: GestureDetector(
            child: FlipCard(
              direction: FlipDirection.VERTICAL,
              front: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorFromHex(node.bg_color),
                    boxShadow: [
                      BoxShadow(
                        color: colorFromHex(node.txt_color) ?? Colors.black,
                        spreadRadius: 0.01,
                        blurRadius: 5,
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            node.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colorFromHex(node.txt_color),
                              fontSize: double.parse(
                                '${15 * node.size}',
                              ),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '${node.max_amt}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          // color: colorFromHex(node.bg_color),
                          // shadows: [Shadow(color: colorFromHex(node.txt_color)!)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              back: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorFromHex(node.bg_color),
                    boxShadow: [
                      BoxShadow(
                        color: colorFromHex(node.txt_color) ?? Colors.black,
                        spreadRadius: 0.01,
                        blurRadius: 5,
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '${node.present_amt} / ${node.max_amt}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          // color: colorFromHex(node.bg_color),
                          // shadows: [Shadow(color: colorFromHex(node.txt_color)!)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onLongPress: () {
              Color nodeTXTcolor = colorFromHex(node.txt_color) ?? Colors.white;
              Color nodeBGcolor = colorFromHex(node.bg_color) ?? Colors.black;

              void changeTXTColor(Color color) {
                setState(() {
                  nodeTXTcolor = color;
                });
              }

              void changeBGColor(Color color) {
                setState(() {
                  nodeBGcolor = color;
                });
              }

              showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: const Text(
                        'Edit Node...',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.only(
                                left: 0, right: 8, top: 8, bottom: 0),
                            title: const Text('Size'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                              ],
                            ),
                          ),
                          TextField(
                            controller: nodeEDIT_inputcontroller__NAME
                              ..text = node.name,
                            decoration: const InputDecoration(
                              label: Text('Name'),
                            ),
                          ),
                          TextField(
                            controller: nodeEDIT_inputcontroller__TARGET_AMT
                              ..text = '${node.max_amt}',
                            decoration: const InputDecoration(
                              label: Text('Target Amt.'),
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.only(
                                left: 0, right: 8, top: 8, bottom: 0),
                            title: const Text('Background Color'),
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
                                            pickerColor: nodeBGcolor,
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
                                backgroundColor: nodeBGcolor,
                              ),
                              child: const Icon(Icons.color_lens),
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.only(
                                left: 0, right: 8, top: 0, bottom: 8),
                            title: const Text('Text Color'),
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
                                            pickerColor: nodeTXTcolor,
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
                                backgroundColor: nodeTXTcolor,
                              ),
                              child: const Icon(Icons.color_lens),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {},
                          child: const Icon(Icons.save),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => Navigator.pop(context));
                          },
                          child: const Icon(Icons.cancel_outlined),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      );
    }

    // SHOW THE NODES
    // https://www.youtube.com/watch?v=XNwL_9ur8R8&ab_channel=JohannesMilke

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: nodeCards,
      ),
    );
  }
}
