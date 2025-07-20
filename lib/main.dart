import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();

  // sets screen to land scape
  await Flame.device.setLandscape();

  runApp(GameWidget(game: FarmGame()));
}

class FarmGame extends FlameGame
    with PanDetector, HasKeyboardHandlerComponents, HasCollisionDetection {
  late final TiledComponent farmComponent;

  @override
  FutureOr<void> onLoad() async {
    farmComponent = await TiledComponent.load('farm.tmx', Vector2.all(32));

    add(farmComponent);
  }
}
