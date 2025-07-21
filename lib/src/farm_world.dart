import 'dart:async';

import 'package:farm/src/farm_game.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'common/utilities/line.dart';
import 'farm_player.dart';

class FarmWorld extends World with HasGameReference<FarmGame>, HasCollisionDetection {
  late final TiledComponent farmTiledComponent;
  late final FarmPlayer farmPlayer;

  final unWalkableComponentEdges = <Line>[];

  @override
  FutureOr<void> onLoad() async {
    farmPlayer = FarmPlayer();

    farmTiledComponent = await TiledComponent.load('farm.tmx', Vector2.all(32));


    addAll([farmTiledComponent, farmPlayer]);

    final worldSize = farmTiledComponent.size;


    game.cameraComponent.moveTo(Vector2(worldSize.x / 2, worldSize.y / 2));
    game.cameraComponent.follow(farmPlayer);
    game.cameraComponent.viewport.add(FpsTextComponent());

    // whatever zoom you set
    // set that value for dividing "halfViewportSize"
    game.cameraComponent.viewfinder.zoom = 1.5;


    // 1.5 is value of zoom
    final halfViewportSize = game.cameraComponent.viewport.size / 1.5;
    game.cameraComponent.setBounds(
      Rectangle.fromCenter(
        center: worldSize / 2,
        size: worldSize - halfViewportSize,
      ),
    );
  }
}
