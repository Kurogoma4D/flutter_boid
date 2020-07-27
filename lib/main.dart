import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_boid/boid.dart';
import 'package:flutter_boid/boid_manager.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Provider<BoidManager>(
        create: (context) => BoidManager(
          width: window.physicalSize.width / window.devicePixelRatio,
          height: window.physicalSize.height / window.devicePixelRatio,
        ),
        lazy: false,
        child: Scaffold(body: const Root()),
      ),
    );
  }
}

class Root extends StatefulWidget {
  const Root({Key key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> with SingleTickerProviderStateMixin {
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
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        ),
        willChange: true,
        painter: BoidPainter(context: context),
      ),
    );
  }
}
