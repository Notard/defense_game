import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:defense_game/flame/defense_frame.dart';
import 'package:defense_game/flame/defense_world.dart';
import 'package:defense_game/flame/defense_camera.dart';

void main() {
  runApp(
    GameWidget(
      game: DefenseFrame(
        world: DefenseWorld(),
        camera: DefenseCamera(),
      ),
    ),
  );
}
