import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:defense_game/funtion/prorgress_bar.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GameItem extends PositionComponent with HasGameRef {
  GameItemType type;
  final int maxHp;
  int nowHp = 0;
  final double effectValue;
  TextComponent? hpTextComponent;
  ProgressBar? progressBar;
  GameItem({
    required super.position,
    required this.type,
    required this.maxHp,
    required this.effectValue,
  });

  @override
  void onLoad() async {
    String spriteFilePath = '';
    if (type == GameItemType.powerUp) {
      spriteFilePath = 'power_item.png';
    } else if (type == GameItemType.speedUp) {
      spriteFilePath = 'speed_item.png';
    }
    size = Vector2(256, 256);
    SpriteComponent spriteComponent = SpriteComponent();
    Sprite itemSprite = Sprite(gameRef.images.fromCache(spriteFilePath));
    spriteComponent.sprite = itemSprite;
    spriteComponent.size = size;
    spriteComponent.anchor = Anchor.center;
    add(spriteComponent);

    nowHp = maxHp;
    hpTextComponent = TextComponent();
    hpTextComponent?.text = nowHp.toString();
    hpTextComponent?.textRenderer = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 72,
        fontWeight: FontWeight.bold,
        fontFamily: '온글잎 은별',
        shadows: [
          Shadow(
            color: Colors.black,
            offset: Offset(4, 4),
            blurRadius: 4,
          ),
        ],
      ),
    );
    hpTextComponent?.anchor = Anchor.center;
    add(hpTextComponent!);
    //hp progress bar
    double itemHeight = spriteComponent.size.y;
    progressBar = ProgressBar(
      backgroundColor: Colors.grey,
      foregroundColor: Colors.green,
      size: Vector2(256, 32),
      position: Vector2(0, -itemHeight / 2),
    );
    progressBar?.anchor = Anchor.topCenter;
    add(progressBar!);
    anchor = Anchor.center;
    super.onLoad();
  }

  int damaged(int damage) {
    nowHp -= damage;
    if (nowHp < 0) {
      nowHp = 0;
    }
    hpTextComponent?.text = nowHp.toString();
    progressBar?.progress = nowHp / maxHp;
    if (nowHp <= 0) {
      EventBus().fire(GameItemInactivateEvent(
        gameItemType: type,
        itemValue: effectValue,
      ));
      removeFromParent();
    }
    return nowHp;
  }

  @override
  void update(double dt) {
    position.y += 200 * dt;
    if (position.y > 960) {
      removeFromParent();
    }
    super.update(dt);
  }
}
