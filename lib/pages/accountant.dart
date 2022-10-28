import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Accountant extends StatefulWidget {
  const Accountant({super.key});

  @override
  State<Accountant> createState() => _AccountantState();
}

int ROWS = 10;
int COLUMNS = 10;

double NODE_X = 200;
double NODE_Y = 200;

String NODES_JSON = '''{
    "1": {
        "NAME": "Headphones",
        "BG_COLOR": "#454545",
        "TXT_COLOR": "#fff",
        "SIZE": "1",
        "COORDS": [100, 200],
        "MAX_AMT": 4000,
        "PRESENT_AMT": 700
    },
    "2": {
        "NAME": "PS5",
        "BG_COLOR": "#fff",
        "TXT_COLOR": "#000000",
        "SIZE": "1",
        "COORDS": [300, 200],
        "MAX_AMT": 4000,
        "PRESENT_AMT": 700
    }
}''';

final NODES = jsonDecode(NODES_JSON);

class _AccountantState extends State<Accountant> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        NODE_X = max(0, NODE_X + details.delta.dx);
        NODE_Y = max(0, NODE_Y + details.delta.dy);

        setState(() {});
      },
      child: Container(
        height: 1100,
        width: 1100,
        // height: double.infinity,
        // width: double.infinity,
        color: Color.fromARGB(255, 17, 17, 17),
        child: CustomPaint(
          painter: NodePainter(),
        ),
      ),
    );
  }
}

class NodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // print(NODES);
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(NODE_X, NODE_Y), 30, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
