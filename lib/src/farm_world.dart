import 'dart:async';

import 'package:farm/src/farm_game.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'common/constants.dart';
import 'common/utilities/line.dart';
import 'components/line_component.dart';
import 'components/unwalkeable_component.dart';
import 'farm_player.dart';

class FarmWorld extends World with HasGameReference<FarmGame>, HasCollisionDetection {
  late final TiledComponent farmComponent;
  late final FarmPlayer farmPlayer;

  final unWalkableComponentEdges = <Line>[];

  @override
  FutureOr<void> onLoad() async {
    farmPlayer = FarmPlayer();

    farmComponent = await TiledComponent.load('farm.tmx', Vector2.all(32));


    // for (final line in unWalkableComponentEdges) {
    //   add(LineComponent.red(line: line, thickness: 3));
    // }

    addAll([farmComponent, farmPlayer]);

    print("tile size: ${farmComponent.size}");

    game.cameraComponent.follow(farmPlayer);
    game.cameraComponent.viewport.add(FpsTextComponent());
    game.cameraComponent.viewfinder.zoom = 2;

    final worldSize = farmComponent.size;
    final halfViewportSize = game.cameraComponent.viewport.size / 2;
    game.cameraComponent.setBounds(
      Rectangle.fromCenter(
        center: worldSize / 2,
        size: worldSize - halfViewportSize,
      ),
    );
  }
}
