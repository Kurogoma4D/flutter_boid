import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart';

final _random = math.Random();

class BaseBirdObject {
  BaseBirdObject({@required this.position, this.maxVelocity = 2.0}) {
    velocity = Vector2(_random.nextDouble(), _random.nextDouble());
  }

  Vector2 position;
  final double maxVelocity;
  Vector2 velocity;
  Vector2 acceleration;
  double ratio;

  void update(Vector2 newAcceleration) {
    acceleration = newAcceleration;
    velocity += acceleration;
    final vNorm = velocity.distanceTo(Vector2.zero());
    ratio = vNorm;

    if (maxVelocity < vNorm) {
      final ratio = maxVelocity / vNorm;
      velocity = velocity * ratio;
    }

    position += velocity;
  }
}

class Bird extends BaseBirdObject {
  Bird(
      {@required this.id,
      Vector2 position,
      this.sakuteki = 80,
      this.dislikeDistance = 20})
      : super(position: position);

  static final maxAccelerationNorm = 0.1;
  static final meanForceRatio = 0.4;
  static final dislikeForceRatio = 5.0;

  final int id;
  final int sakuteki;
  final int dislikeDistance;

  Vector2 nextAcceleration(List<Bird> nearBirds) {
    if (nearBirds.isEmpty) return Vector2.zero();

    final velocities = nearBirds.map((e) => e.velocity).toList();
    final positions = nearBirds.map((e) => e.position).toList();
    final vMean = velocities.reduce((value, element) => value + element) /
        velocities.length.toDouble();
    final pMean = positions.reduce((value, element) => value + element) /
        positions.length.toDouble();

    final vDirection = (vMean - velocity).normalized() * meanForceRatio;
    final pDirection = (pMean - position).normalized();

    var direction = pDirection + vDirection;

    final tooNearBirdPositions = filterByDistance(
      nearBirds,
      position,
      dislikeDistance,
    );

    if (tooNearBirdPositions.isNotEmpty) {
      final positions = tooNearBirdPositions.map((e) => e.position).toList();
      final tooNearMeanPos =
          positions.reduce((value, element) => value + element) /
              positions.length.toDouble();

      final tooNearDirection =
          (tooNearMeanPos - position).normalized() * dislikeForceRatio;
      direction -= tooNearDirection;
    }

    return direction.normalized() * maxAccelerationNorm;
  }
}

List<Bird> filterByDistance(
  List<Bird> birds,
  Vector2 viewForm,
  int maxDistance,
) {
  return birds
      .where((bird) => bird.position.distanceTo(viewForm) < maxDistance)
      .toList();
}
