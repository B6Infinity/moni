// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moni/db/flow_database.dart';
import 'package:moni/db/nodes_databse.dart';
import 'package:moni/model/Flow.dart';
import 'package:moni/model/flow.dart' as m_flow;
import 'package:moni/utils/controllers.dart';
import 'package:moni/utils/methods.dart';

class Recorder extends StatefulWidget {
  const Recorder({super.key});

  @override
  State<Recorder> createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  late var allNodes;
  late var allFlows;

  bool isBodyLoading = false;

  @override
  void initState() {
    super.initState();

    refreshData();
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
              '₹ ${flow.amt} /-',
              style: TextStyle(
                color: flow.is_income ? Colors.green : Colors.red,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(flow.name),
            trailing: Text(
                '${flow.date_of_flow.day}.${flow.date_of_flow.month}.${flow.date_of_flow.year}n'),
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
                            bottomRight: Radius.circular(30))),
                    child: Center(
                        child: Text(
                      '₹ 50,000',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
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
                    )),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(children: moneyFlows),
                  ),
                )
              ],
            ),
    );
  }

  void addFlow({bool isIncome = true}) {
    //VARS
    DateTime dateOfFlow = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                    // CREATE FLOW

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

                    MoneyFlow createdFlow = await FlowDatabase.instance.create(
                      MoneyFlow(
                        name: flow_inputcontroller__NAME.text,
                        amt: int.parse(flow_inputcontroller__AMT.text),
                        date_of_flow: dateOfFlow,
                        is_income: isIncome,
                      ),
                    );

                    print(createdFlow);

                    // CLEAN UP

                    // ignore: use_build_context_synchronously
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
