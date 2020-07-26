import 'package:flutter/material.dart';
import 'package:flutter_boid/boid.dart';
import 'package:vector_math/vector_math.dart';
import 'package:provider/provider.dart';

import 'base_object.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

final _random = math.Random();
const SIZE = 1200.0;
const BIRD_NUMBER = 40;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<BoidManager>(
      create: (context) => BoidManager(
        width: SIZE,
        height: SIZE,
      ),
      lazy: false,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(body: const Root()),
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
        size: Size(SIZE, SIZE),
        willChange: true,
        painter: BoidPainter(context: context),
      ),
    );
  }
}

class BoidManager {
  BoidManager({this.width, this.height}) {
    birds = List.generate(BIRD_NUMBER, (index) {
      final x = width * (0.5 + _random.nextDouble()) / 2;
      final y = height * (0.5 + _random.nextDouble()) / 2;
      return Bird(id: index, position: Vector2(x, y));
    });
  }

  final double width;
  final double height;
  List<Bird> birds;

  void next() {
    final accelerations = birds.map((bird) {
      final birdsCanView = filterByDistance(
          birds.where((b) => b != bird).toList(), bird.position, bird.sakuteki);
      return bird.nextAcceleration(birdsCanView);
    }).toList();

    for (var i = 0; i < birds.length; i++) {
      final acceleration = accelerations[i];
      final bird = birds[i];

      if (bird.position.x > width) {
        acceleration.add(Vector2(-1, 0));
      }
      if (bird.position.x < 0) {
        acceleration.add(Vector2(1, 0));
      }
      if (bird.position.y > height) {
        acceleration.add(Vector2(0, -1));
      }
      if (bird.position.y < 0) {
        acceleration.add(Vector2(0, 1));
      }

      bird.update(acceleration);
    }
  }
}
