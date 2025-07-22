import 'dart:async';

import 'package:farm/src/farm_player.dart';
import 'package:farm/src/farm_world.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

class FarmGame extends FlameGame
    with PanDetector, HasKeyboardHandlerComponents, HasCollisionDetection {
  FarmGame() : world = FarmWorld() {
    cameraComponent = CameraComponent(world: world);
  }

  late final CameraComponent cameraComponent;

  @override
  final FarmWorld world;

  @override
  FutureOr<void> onLoad() async {
    debugMode = true;
    addAll([cameraComponent, world]);
  }
}
