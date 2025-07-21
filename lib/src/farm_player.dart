import 'dart:async';

import 'package:farm/src/farm_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class FarmPlayer extends SpriteAnimationComponent
    with HasGameReference<FarmGame>, CollisionCallbacks, KeyboardHandler {
  //
  FarmPlayer() : super(size: Vector2.all(64), anchor: Anchor.center);

  late final Vector2 _initialPosition;
  final double _speed = 80;
  Vector2 _direction = Vector2.zero();

  late final SpriteAnimation _idle;
  late final SpriteAnimation _walkDown;
  late final SpriteAnimation _walkUp;
  late final SpriteAnimation _walkSide;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    _idle = await game.loadSpriteAnimation(
      'characters/Idle_Down-Sheet.png',
      SpriteAnimationData.sequenced(amount: 4, stepTime: 0.5, textureSize: Vector2.all(64)),
    );

    _walkDown = await game.loadSpriteAnimation(
      'characters/Walk_Down-Sheet.png',
      SpriteAnimationData.sequenced(amount: 4, stepTime: 0.5, textureSize: Vector2.all(64)),
    );

    _walkUp = await game.loadSpriteAnimation(
      'characters/Walk_Up-Sheet.png',
      SpriteAnimationData.sequenced(amount: 4, stepTime: 0.5, textureSize: Vector2.all(64)),
    );

    _walkSide = await game.loadSpriteAnimation(
      'characters/Walk_Side-Sheet.png',
      SpriteAnimationData.sequenced(amount: 4, stepTime: 0.5, textureSize: Vector2.all(64)),
    );

    animation = _idle;

    // center of the map
    _initialPosition = game.world.farmTiledComponent.size / 2;
    position = _initialPosition.clone();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_direction != Vector2.zero()) {
      final newPosition = position + _direction.normalized() * _speed * dt;

      // Get map size from the loaded map (in pixels)
      final mapSize = game.world.farmTiledComponent.size;
      final halfSize = size / 2;

      // Clamp position so player stays inside the map
      final clampedX = newPosition.x.clamp(halfSize.x, mapSize.x - halfSize.x);
      final clampedY = newPosition.y.clamp(halfSize.y, mapSize.y - halfSize.y);

      position = Vector2(clampedX, clampedY);

      // Change animation based on direction
      if (_direction.y > 0) {
        animation = _walkDown;
      } else if (_direction.y < 0) {
        animation = _walkUp;
      } else if (_direction.x < 0) {
        animation = _walkSide;
        scale.x = -1;
      } else if (_direction.x > 0) {
        animation = _walkSide;
        scale.x = 1;
      }
    } else {
      animation = _idle;
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _direction = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      _direction += Vector2(0, -1);
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      _direction += Vector2(0, 1);
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      _direction += Vector2(-1, 0);
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      _direction += Vector2(1, 0);
    }


    return true;
  }


  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);


  }
}
