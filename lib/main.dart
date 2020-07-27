import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_boid/boid_canvas.dart';
import 'package:flutter_boid/boid_manager.dart';
import 'package:provider/provider.dart';

import 'footer.dart';

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

class Root extends StatelessWidget {
  const Root({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          onExit: (_) => context.read<BoidManager>().deactivateMouse(),
          onHover: (detail) => context
              .read<BoidManager>()
              .updateDetail(detail.localPosition.dx, detail.localPosition.dy),
          child: const BoidCanvas(),
        ),
        const SizedBox(
          height: FOOTER_SIZE,
          child: const Footer(),
        )
      ],
    );
  }
}
