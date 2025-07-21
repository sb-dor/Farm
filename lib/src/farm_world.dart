import 'dart:async';

import 'package:farm/src/farm_game.dart';
import 'package:flame/components.dart';
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

    final objectLayer = farmComponent.tileMap.getLayer<ObjectGroup>('Objects')!;
    for (final TiledObject object in objectLayer.objects) {
      if (!object.isPolygon) continue;
      if (!object.properties.byName.containsKey('blocksMovement')) return;
      final vertices = <Vector2>[];
      Vector2? lastPoint;
      Vector2? nextPoint;
      Vector2? firstPoint;
      for (final point in object.polygon) {
        nextPoint = Vector2((point.x + object.x) * worldScale, (point.y + object.y) * worldScale);
        firstPoint ??= nextPoint;
        vertices.add(nextPoint);

        // If there is a last point, or this is the end of the list, we have a
        // line to add to our cached list of lines
        if (lastPoint != null) {
          unWalkableComponentEdges.add(Line(firstPoint, nextPoint));
        }
        lastPoint = nextPoint;
      }
      unWalkableComponentEdges.add(Line(lastPoint!, firstPoint!));
      add(UnWalkableComponent(vertices));
    }

    for (final line in unWalkableComponentEdges) {
      add(LineComponent.red(line: line, thickness: 3));
    }

    addAll([farmComponent, farmPlayer]);

    game.cameraComponent.follow(farmPlayer);
    game.cameraComponent.viewport.add(FpsTextComponent());
  }
}
