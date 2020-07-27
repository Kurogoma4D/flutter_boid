import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_boid/boid.dart';
import 'package:flutter_boid/boid_manager.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

const FOOTER_SIZE = 80.0;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider(
        create: (context) => BoidManager(
          width:
              window.physicalSize.width / window.devicePixelRatio - FOOTER_SIZE,
          height: window.physicalSize.height / window.devicePixelRatio -
              FOOTER_SIZE,
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
    return Column(
      children: [
        RepaintBoundary(
          child: CustomPaint(
            size: Size(
              MediaQuery.of(context).size.width - FOOTER_SIZE,
              MediaQuery.of(context).size.height - FOOTER_SIZE,
            ),
            willChange: true,
            painter: BoidPainter(context: context),
          ),
        ),
        const SizedBox(
          height: FOOTER_SIZE,
          child: const Footer(),
        )
      ],
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final distance = context.select((BoidManager m) => m.dislikeDistance);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600),
      child: Column(
        children: [
          Center(
            child: Text('離れやすさ'),
          ),
          Slider(
            label: '$distance',
            value: distance.toDouble(),
            onChanged: (value) => context
                .read<BoidManager>()
                .updateDislikeDistance(value.floor()),
            min: 10,
            max: 100,
          ),
        ],
      ),
    );
  }
}
