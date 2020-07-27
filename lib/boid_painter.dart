import 'package:flutter/widgets.dart';
import 'package:flutter_boid/boid_manager.dart';
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
      final largePaint = Paint()
        ..color = lerped(bird.id).withOpacity(0.1)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(bird.position.x, bird.position.y), 4, paint);
      canvas.drawCircle(Offset(bird.position.x, bird.position.y),
          bird.sakuteki.toDouble(), largePaint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  Color lerped(int index) {
    return Color.lerp(
        Color(0xff0044aa), Color(0xff66ff44), index / BIRD_NUMBER);
  }
}
