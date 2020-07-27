import 'package:flutter/material.dart';
import 'package:flutter_boid/boid_manager.dart';
import 'package:provider/provider.dart';

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
