import 'package:flutter/foundation.dart';
import 'package:flutter_boid/base_object.dart';
import 'package:vector_math/vector_math.dart';

import 'dart:math' as math;

final _random = math.Random();
const BIRD_NUMBER = 40;

class BoidManager extends ChangeNotifier {
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
  int dislikeDistance = 20;

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

  void updateDislikeDistance(int value) {
    dislikeDistance = value;
    birds = [
      for (final bird in birds) bird..dislikeDistance = value,
    ];
    notifyListeners();
  }
}
