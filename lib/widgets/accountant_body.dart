// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:moni/db/nodes_databse.dart';
import 'package:moni/model/node.dart';
import 'package:moni/utils/constants.dart';
import 'package:moni/utils/controllers.dart';
import 'package:moni/utils/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountantBody extends StatefulWidget {
  const AccountantBody({
    super.key,
    required this.NODES,
    required this.idleMoney,
    required this.prefs,
  });

  @override
  State<AccountantBody> createState() => _AccountantBodyState();

  final List<Node> NODES;
  final int idleMoney;
  final SharedPreferences prefs;
}

class _AccountantBodyState extends State<AccountantBody> {
  void rebuildNodes() {
    // for (var node in widget.NODES) {
    //   print(node.toJson());
    // }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> nodeCards = [];

    for (var node in widget.NODES) {
      // print(node.toJson());

      nodeCards.add(
        StaggeredGridTile.count(
          crossAxisCellCount: node.size,
          mainAxisCellCount: node.size,
          child: FlipCard(
            direction: FlipDirection.VERTICAL,
            front: GestureDetector(
              child: Container(
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
                        NumberFormat.decimalPattern('en_us')
                            .format(node.max_amt),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          // color: colorFromHex(node.bg_color),
                          // shadows: [
                          //   Shadow(
                          //     color: colorFromHex(node.txt_color)!,
                          //     blurRadius: 5,
                          //     offset: const Offset(0.5, 0.5),
                          //   ),
                          //   Shadow(
                          //     color: colorFromHex(node.txt_color)!,
                          //     blurRadius: 5,
                          //     offset: const Offset(-0.5, -0.5),
                          //   ),
                          // ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onLongPress: () {
                Color nodeTXTcolor =
                    colorFromHex(node.txt_color) ?? Colors.white;
                Color nodeBGcolor = colorFromHex(node.bg_color) ?? Colors.black;

                int nodeSize = node.size;

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
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.square,
                                  size: (10 * nodeSize).toDouble(),
                                  color: nodeBGcolor,
                                  shadows: [
                                    Shadow(
                                        color: nodeTXTcolor,
                                        offset: const Offset(2, 2),
                                        blurRadius: 2),
                                  ],
                                ),
                                onPressed: () {
                                  setState(
                                    () => nodeSize =
                                        nodeSize == 3 ? 1 : nodeSize + 1,
                                  );
                                },
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
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
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
                                              child: const Text('OK'))
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
                                              child: const Text('OK'))
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
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Are you sure?',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          NodesDatabase.instance
                                              .deleteNode(node.id!);

                                          widget.NODES.remove(node);

                                          rebuildNodes();
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'YES',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('NO'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              // FRISK DATA
                              if (nodeEDIT_inputcontroller__NAME.text.isEmpty) {
                                showSnackBarMSG(context, 'Name is empty');
                                return;
                              }
                              if (nodeEDIT_inputcontroller__TARGET_AMT
                                      .text.isEmpty ||
                                  int.parse(nodeEDIT_inputcontroller__TARGET_AMT
                                          .text) ==
                                      0) {
                                showSnackBarMSG(
                                    context, 'Target Amount is empty');
                                return;
                              }
                              if (int.parse(nodeEDIT_inputcontroller__TARGET_AMT
                                      .text) <
                                  node.present_amt) {
                                showSnackBarMSG(context,
                                    'Target amount is less than present amount');
                                return;
                              }

                              Node newNode = Node(
                                id: node.id,
                                name: nodeEDIT_inputcontroller__NAME.text,
                                bg_color: '#${colorToHex(nodeBGcolor)}',
                                txt_color: '#${colorToHex(nodeTXTcolor)}',
                                size: nodeSize,
                                max_amt: int.parse(
                                    nodeEDIT_inputcontroller__TARGET_AMT.text),
                                present_amt: node.present_amt,
                              );

                              int updRES =
                                  await NodesDatabase.instance.updateNode(
                                node.id!,
                                newNode,
                              );

                              if (updRES == 1) {
                                for (var NODE in widget.NODES) {
                                  if (NODE.id == node.id) {
                                    widget.NODES[widget.NODES.indexOf(node)] =
                                        newNode;
                                  }
                                }
                                rebuildNodes();
                                Navigator.pop(context);
                              }
                            },
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
            back: GestureDetector(
              child: Container(
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
                        '${NumberFormat.decimalPattern('en_us').format(node.present_amt)} / ${NumberFormat.decimalPattern('en_us').format(node.max_amt)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          // color: colorFromHex(node.bg_color),
                          // shadows: [Shadow(color: colorFromHex(node.txt_color)!)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onLongPress: () {
                print(widget.idleMoney);
                showDialog(
                  context: context,
                  builder: (context) {
                    bool isInserting = true;
                    return StatefulBuilder(
                      builder: (context, setDialogState) {
                        return AlertDialog(
                          title: GestureDetector(
                            child: Text(
                              '${isInserting ? "Add" : "Remove"} Money ${isInserting ? "to" : "from"} "${node.name}"',
                              style: TextStyle(
                                color: isInserting ? Colors.green : Colors.red,
                              ),
                            ),
                            onTap: () {
                              if (isInserting) {
                                isInserting = false;
                              } else {
                                isInserting = true;
                              }
                              setDialogState(
                                () {},
                              );
                            },
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: idleMoney_inputcontroller__AMT,
                                decoration: InputDecoration(
                                  label: Text(
                                      'Amount (Limit: ₹ ${NumberFormat.decimalPattern('en_us').format(isInserting ? widget.idleMoney : node.present_amt)})'),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 25, bottom: 10),
                                child: Text(
                                  'Remaining Amount: ₹ ${NumberFormat.decimalPattern('en_us').format(node.max_amt - node.present_amt)} /-',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.green[400],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  'Target Amount: ₹ ${NumberFormat.decimalPattern('en_us').format(node.max_amt)} /-',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                if (isInserting) {
                                  if (idleMoney_inputcontroller__AMT
                                          .text.isEmpty ||
                                      int.parse(idleMoney_inputcontroller__AMT
                                              .text) ==
                                          0 ||
                                      int.parse(idleMoney_inputcontroller__AMT
                                              .text) >
                                          widget.idleMoney ||
                                      int.parse(idleMoney_inputcontroller__AMT
                                              .text) >
                                          node.max_amt) {
                                    showSnackBarMSG(context, 'Invalid Amount');
                                    return;
                                  }
                                } else {
                                  // IS EXTRACTING
                                  if (idleMoney_inputcontroller__AMT
                                          .text.isEmpty ||
                                      int.parse(idleMoney_inputcontroller__AMT
                                              .text) ==
                                          0 ||
                                      int.parse(idleMoney_inputcontroller__AMT
                                              .text) >
                                          node.present_amt) {
                                    showSnackBarMSG(context, 'Invalid Amount');
                                    return;
                                  }
                                }

                                int amtToInsert = int.parse(
                                    idleMoney_inputcontroller__AMT
                                        .text); // or Extract

                                // Update the Node
                                Node newNode = Node(
                                  id: node.id,
                                  name: node.name,
                                  bg_color: node.bg_color,
                                  txt_color: node.txt_color,
                                  size: node.size,
                                  max_amt: node.max_amt,
                                  present_amt: isInserting
                                      ? node.present_amt + amtToInsert
                                      : node.present_amt - amtToInsert,
                                );

                                int updRES =
                                    await NodesDatabase.instance.updateNode(
                                  node.id!,
                                  newNode,
                                );

                                if (updRES == 1) {
                                  for (var NODE in widget.NODES) {
                                    if (NODE.id == node.id) {
                                      widget.NODES[widget.NODES.indexOf(node)] =
                                          newNode;
                                    }
                                  }
                                  rebuildNodes();
                                }
                                // Deduct from idleMoney

                                await widget.prefs.setInt(
                                    idleMoney_ShPrefKEY,
                                    isInserting
                                        ? widget.idleMoney - amtToInsert
                                        : widget.idleMoney + amtToInsert);

                                setDialogState(
                                  () {},
                                );
                                setState(
                                  () {
                                    idleMoney_inputcontroller__AMT.text = '';
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              child: Text(isInserting ? 'INSERT' : 'EXTRACT'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'CANCEL',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
    }

    // SHOW THE NODES

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            StaggeredGrid.count(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: nodeCards,
            )
          ],
        ),
        floatingActionButton: widget.idleMoney > 0
            ? FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Center(
                          child: Text(
                            '₹ ${NumberFormat.decimalPattern('en_us').format(widget.idleMoney)} /-',
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  k_m_b_generator(widget.idleMoney),
                  style: const TextStyle(color: Colors.black),
                ),
              )
            : null,
      ),
    );
  }
}
