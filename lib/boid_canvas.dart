import 'package:flutter/material.dart';
import 'package:flutter_boid/boid_painter.dart';
import 'package:flutter_boid/boid_manager.dart';
import 'package:flutter_boid/main.dart';
import 'package:provider/provider.dart';

class BoidCanvas extends StatefulWidget {
  const BoidCanvas({Key key}) : super(key: key);

  @override
  _BoidCanvasState createState() => _BoidCanvasState();
}

class _BoidCanvasState extends State<BoidCanvas>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(seconds: 3200), vsync: this)
      ..addListener(() => setState(() {
            context.read<BoidManager>().next();
          }))
      ..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(
          MediaQuery.of(context).size.width - FOOTER_SIZE,
          MediaQuery.of(context).size.height - FOOTER_SIZE,
        ),
        willChange: true,
        painter: BoidPainter(context: context),
      ),
    );
  }
}
