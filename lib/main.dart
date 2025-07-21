import 'dart:async';

import 'package:farm/src/farm_game.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Flame.device.fullScreen();

  // sets screen to land scape
  await Flame.device.setLandscape();

  runApp(GameStarter());
}

class GameStarter extends StatelessWidget {
  const GameStarter({super.key});

  @override
  Widget build(BuildContext context) {
    return Focus(
      // for removing system sound while tapping on keyboard
      onKeyEvent: (FocusNode node, KeyEvent event) => KeyEventResult.handled,
      child: GameWidget(game: FarmGame()),
    );
  }
}
