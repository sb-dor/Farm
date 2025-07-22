import 'dart:async';

import 'package:farm/src/farm_game.dart';
import 'package:farm/src/farm_player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class FarmEnemy extends SpriteAnimationComponent
    with HasGameReference<FarmGame>, CollisionCallbacks {
  FarmEnemy({required Vector2 position}) : super(position: position, anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      "enemies/Orc-Idle-Sheet.png",
      SpriteAnimationData.sequenced(amount: 4, stepTime: 0.1, textureSize: Vector2.all(32)),
    );

    add(RectangleHitbox());
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is FarmPlayer) {
      removeFromParent();
    }
  }
}
