import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GameItem extends PositionComponent {
  final GameItemType type;
  GameItemType get gameItemType => type;
  final int maxHp;
  final bool isDebuff;
  int nowHp = 0;

  GameItem({
    required super.position,
    required this.type,
    required this.maxHp,
    required this.isDebuff,
  });

  @override
  void onLoad() async {
    nowHp = maxHp;
    super.onLoad();
    String spritePath = '';
    switch (type) {
      case GameItemType.powerUp:
        spritePath = 'power_item.png';
        break;
      case GameItemType.speedUp:
        spritePath = 'speed_item.png';
        break;
      case GameItemType.health:
        spritePath = 'hp_item.png';
        break;
    }
    SpriteComponent spriteComponent = SpriteComponent();
    Sprite itemSprite = await Sprite.load(spritePath);
    spriteComponent.sprite = itemSprite;
    spriteComponent.size = Vector2(256, 256);

    if (isDebuff) {
      spriteComponent.paint = Paint()
        ..colorFilter = const ColorFilter.mode(
            Color.fromARGB(255, 255, 0, 0), BlendMode.modulate)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
    }
    spriteComponent.anchor = Anchor.center;
    add(spriteComponent);

    TextComponent textComponent = TextComponent();
    textComponent.text = nowHp.toString();
    textComponent.textRenderer = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 64,
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
    textComponent.anchor = Anchor.center;

    add(textComponent);
  }

  // 매 프레임마다 아래로 이동
  @override
  void update(double dt) {
    position.y += 100 * dt;
    super.update(dt);
    if (position.y > 1000) {
      removeFromParent();
    }
  }

  void damaged(int damage) {
    nowHp -= damage;
    if (nowHp <= 0) {
      EventBus().fire(GameItemDeactivateEvent(
        gameItemType: type,
        itemValue: nowHp.toDouble(),
      ));
    }
  }
}
