import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:defense_game/funtion/prorgress_bar.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Enemy extends PositionComponent with HasGameRef {
  final int uniqueId;
  final int maxHp;
  final double speed;
  final int damage;
  final String imageName;
  ProgressBar? progressBar;
  int hp = 0;
  Enemy(
      {required this.uniqueId,
      required this.maxHp,
      required this.speed,
      required this.damage,
      required this.imageName,
      required super.position}) {
    hp = maxHp;
  }

  @override
  void onLoad() {
    super.onLoad();
    setSprite();
    progressBar = ProgressBar(
      size: Vector2(100, 10),
      backgroundColor: Colors.grey,
      foregroundColor: Colors.red,
    );
    add(progressBar!);
  }

  void setSprite() {
    Sprite sprite = Sprite(gameRef.images.fromCache(imageName));
    size = Vector2(150, 150);
    SpriteComponent spriteComponent = SpriteComponent(
      sprite: sprite,
      size: Vector2(100, 150),
    );
    spriteComponent.anchor = Anchor.topLeft;
    add(spriteComponent);
    anchor = Anchor.center;
  }

  void damaged(int damage) {
    hp -= damage;
    if (hp < 0) {
      hp = 0;
    }
    if (hp <= 0) {
      removeFromParent();
    }
    progressBar?.setProgress(hp / maxHp);
  }

  @override
  void update(double dt) {
    super.update(dt);
    Vector2 velocity = Vector2(0, 1);
    position += velocity * speed * dt;
    if (position.y > gameRef.size.y / 2) {
      removeFromParent();
      EventBus().fire(ChangePageEvent(pageType: PageType.gameOver));
    }
  }
}
