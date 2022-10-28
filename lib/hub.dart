import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moni/pages/accountant.dart';
import 'package:moni/pages/recorder.dart';

class Hub extends StatefulWidget {
  const Hub({super.key});

  @override
  State<Hub> createState() => _HubState();
}

const List PAGES = [
  Recorder(),
  Accountant(),
];

int activePageIndex = 0;

class _HubState extends State<Hub> {
  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: PAGES[activePageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.fiber_manual_record_rounded, size: 30),
          Icon(Icons.data_thresholding_rounded, size: 30),
        ],
        color: primaryColor,
        buttonBackgroundColor: Colors.blue,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 200),
        onTap: (index) {
          setState(() {
            activePageIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
