import 'dart:async';

import 'package:farm/src/farm_enemy.dart';
import 'package:farm/src/farm_game.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'common/utilities/line.dart';
import 'farm_player.dart';

class FarmWorld extends World with HasGameReference<FarmGame> {
  late final TiledComponent farmTiledComponent;
  late final FarmPlayer farmPlayer;

  final unWalkableComponentEdges = <Line>[];

  @override
  FutureOr<void> onLoad() async {
    //loading player
    farmPlayer = FarmPlayer();

    // loading tile map
    farmTiledComponent = await TiledComponent.load('farm.tmx', Vector2.all(32));

    addAll([farmTiledComponent, farmPlayer]);

    // setting camera
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
      Rectangle.fromCenter(center: worldSize / 2, size: worldSize - halfViewportSize),
    );

    // loading enemies
    final enemies = farmTiledComponent.tileMap.getLayer<ObjectGroup>('Enemies');
    if (enemies != null) {
      for (final enemy in enemies.objects) {
        final position = Vector2(enemy.x, enemy.y);
        final enemyComponent = FarmEnemy(position: position);
        add(enemyComponent);
      }
    }
  }
}
