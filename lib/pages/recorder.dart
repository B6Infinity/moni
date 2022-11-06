// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:moni/db/flow_database.dart';
import 'package:moni/db/nodes_databse.dart';
import 'package:moni/model/Flow.dart';
import 'package:moni/model/flow.dart' as m_flow;
import 'package:moni/model/node.dart';
import 'package:moni/utils/constants.dart';
import 'package:moni/utils/controllers.dart';
import 'package:moni/utils/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Recorder extends StatefulWidget {
  const Recorder({super.key});

  @override
  State<Recorder> createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  late SharedPreferences prefs;
  late var allNodes;
  var allFlows = [];
  late int liveMoney;
  late int idleMoney;

  bool isBodyLoading = false;

  @override
  void initState() {
    super.initState();

    initSharedPref();

    refreshData();
  }

  Future initSharedPref() async {
    prefs = await SharedPreferences.getInstance();

    try {
      prefs.getInt(liveMoney_ShPrefKEY);
    } catch (e) {
      SharedPreferences.setMockInitialValues({});
    }

    if (prefs.getInt(liveMoney_ShPrefKEY) == null) {
      // Instantiate SharedPref
      await prefs.setInt(liveMoney_ShPrefKEY, 0);
    }
    if (prefs.getInt(idleMoney_ShPrefKEY) == null) {
      // Instantiate SharedPref
      await prefs.setInt(idleMoney_ShPrefKEY, 0);
    }

    liveMoney = prefs.getInt(liveMoney_ShPrefKEY)!;
    idleMoney = prefs.getInt(idleMoney_ShPrefKEY)!;
  }

  void refreshData() async {
    setState(() {
      isBodyLoading = true;
    });

    allNodes = await NodesDatabase.instance.readAllNodes();
    allFlows = await FlowDatabase.instance.readAllFlows();

    setState(() {
      isBodyLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> moneyFlows = [];

    for (var flow in allFlows) {
      String flowTime = (flow.date_of_flow.hour > 12)
          ? '${flow.date_of_flow.hour - 12}:${flow.date_of_flow.minute} PM'
          : '${flow.date_of_flow.hour}:${flow.date_of_flow.minute} AM';
      moneyFlows.add(
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListTile(
            tileColor: Theme.of(context).primaryColor,
            leading: Icon(
              flow.is_income ? Icons.add : Icons.remove,
              color: flow.is_income ? Colors.green : Colors.red,
              size: 30,
            ),
            title: Text(
              '₹ ${NumberFormat.decimalPattern('en_us').format(flow.amt)} /-',
              style: TextStyle(
                color: flow.is_income ? Colors.green : Colors.red,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(flow.name),
            trailing: Text(
              '${flow.date_of_flow.day}.${flow.date_of_flow.month}.${flow.date_of_flow.year}\n$flowTime',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: isBodyLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (liveMoney > 0)
                                ? Colors.green[800]!
                                : Colors.red[800]!,
                            blurRadius: 5,
                            offset: Offset(0, 10),
                          )
                        ]),
                    child: Center(
                      child: Text(
                        '₹ ${NumberFormat.decimalPattern('en_us').format(liveMoney)}',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: (liveMoney > 0) ? Colors.green : Colors.red,
                          // shadows: [
                          //   Shadow(
                          //     color: Colors.green,
                          //     blurRadius: 20,
                          //     offset: Offset(2, 2),
                          //   ),
                          //   Shadow(
                          //     color: Colors.green,
                          //     blurRadius: 20,
                          //     offset: Offset(-2, -2),
                          //   ),
                          //   Shadow(
                          //     color: Colors.green,
                          //     blurRadius: 20,
                          //     offset: Offset(4, 4),
                          //   ),
                          //   Shadow(
                          //     color: Colors.green,
                          //     blurRadius: 20,
                          //     offset: Offset(-4, -4),
                          //   ),
                          // ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: addFlow,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[800]),
                      child: Icon(Icons.download),
                    ),
                    ElevatedButton(
                      onPressed: () => addFlow(isIncome: false),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[800]),
                      child: Icon(Icons.upload),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Icon(
                    Icons.history,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: moneyFlows.reversed.toList(),
                  ),
                )
              ],
            ),
    );
  }

  void addFlow({bool isIncome = true}) {
    //VARS
    DateTime dateOfFlow = DateTime.now();

    int? activeNode;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            List<Widget> nodeRow = [];

            for (var node in allNodes) {
              nodeRow.add(
                GestureDetector(
                  onTap: () {
                    setDialogState(() {
                      activeNode = node.id;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: activeNode == node.id ? Colors.grey : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              offset: Offset(2, 2),
                              blurRadius: 2,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: colorFromHex(node.bg_color),
                        ),
                        padding: const EdgeInsets.all(8),
                        height: 80,
                        width: 80,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              node.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colorFromHex(node.txt_color),
                              ),
                            ),
                            Text(
                              NumberFormat.decimalPattern('en_us')
                                  .format(node.present_amt),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            return AlertDialog(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add Flow...',
                      style: TextStyle(
                        fontSize: 25,
                        color: isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                  Switch(
                    value: isIncome,
                    onChanged: (value) {
                      setDialogState(() {
                        isIncome = (isIncome == true) ? false : true;
                      });
                    },
                    activeTrackColor: Colors.green,
                    activeColor: Colors.green[300],
                    inactiveTrackColor: Colors.red,
                    inactiveThumbColor: Colors.red[300],
                  )
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: flow_inputcontroller__NAME,
                    decoration: InputDecoration(label: Text('Name')),
                  ),
                  TextField(
                    controller: flow_inputcontroller__AMT,
                    decoration: InputDecoration(label: Text('Amount')),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  Container(
                      child: isIncome
                          ? null
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 20, bottom: 8),
                                  child: Text(
                                    'From',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: nodeRow,
                                  ),
                                ),
                              ],
                            )),
                  ListTile(
                    contentPadding: EdgeInsets.only(top: 8, bottom: 8),
                    title: Text(
                      'Date',
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: TextButton(
                      child: Icon(Icons.calendar_today),
                      onPressed: () async {
                        dateOfFlow = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2003),
                              lastDate: DateTime.now(),
                            ) ??
                            DateTime.now();
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('CREATE'),
                  onPressed: () async {
                    //
                    // CREATE FLOW --------------------------------------------------------------------------

                    // FRISK DATA
                    if (flow_inputcontroller__NAME.text.isEmpty) {
                      showSnackBarMSG(context, 'Name is empty...');
                      return;
                    }
                    if (flow_inputcontroller__AMT.text.isEmpty ||
                        int.parse(flow_inputcontroller__AMT.text) == 0) {
                      showSnackBarMSG(context, 'Amount is empty...');
                      return;
                    }

                    // IF EXPENDITURE ---------
                    Node? node2deductFrom =
                        await NodesDatabase.instance.readNode(activeNode!);

                    if (!isIncome) {
                      if (activeNode == null) {
                        showSnackBarMSG(context, 'Select a node...');
                        return;
                      }

                      if (node2deductFrom!.present_amt <
                          int.parse(flow_inputcontroller__AMT.text)) {
                        showSnackBarMSG(context,
                            'Not Enough money present in "${node2deductFrom.name}"');
                        return;
                      }

                      // ALL GOOD
                      // Deduct from Node
                    }

                    // Create Flow Object
                    MoneyFlow createdFlow = await FlowDatabase.instance.create(
                      MoneyFlow(
                        name: flow_inputcontroller__NAME.text,
                        amt: int.parse(flow_inputcontroller__AMT.text),
                        date_of_flow: dateOfFlow,
                        is_income: isIncome,
                      ),
                    );

                    // INCOME -> Add to liveMoney
                    if (isIncome) {
                      liveMoney += createdFlow.amt;
                      idleMoney += liveMoney;
                    } else {
                      liveMoney -= createdFlow.amt;
                      // EXPENDITURE -> Deduct from Node

                      // node2deductFrom.present_amt
                      NodesDatabase.instance.updateNode(
                        activeNode!,
                        Node(
                          id: node2deductFrom!.id,
                          name: node2deductFrom.name,
                          bg_color: node2deductFrom.bg_color,
                          txt_color: node2deductFrom.txt_color,
                          size: node2deductFrom.size,
                          max_amt: node2deductFrom.max_amt,
                          present_amt:
                              node2deductFrom.present_amt - createdFlow.amt,
                        ),
                      );
                    }

                    await prefs.setInt(liveMoney_ShPrefKEY, liveMoney);
                    await prefs.setInt(idleMoney_ShPrefKEY, idleMoney);
                    // CLEAN UP

                    Navigator.pop(context);
                    flow_inputcontroller__NAME.text = '';
                    flow_inputcontroller__AMT.text = '';

                    setState(() {
                      refreshData();
                    });
                    //
                  },
                ),
                TextButton(
                  child: Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
