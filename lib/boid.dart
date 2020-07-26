import 'package:flutter/widgets.dart';
import 'package:flutter_boid/main.dart';
import 'package:provider/provider.dart';

class BoidPainter extends CustomPainter {
  BoidPainter({this.context});

  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    context.read<BoidManager>().birds.forEach((bird) {
      final paint = Paint()
        ..color = lerped(bird.id)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(bird.position.x, bird.position.y), 4, paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  Color lerped(int index) {
    return Color.lerp(
        Color(0xffff0000), Color(0xff00ff00), index / BIRD_NUMBER);
  }
}
