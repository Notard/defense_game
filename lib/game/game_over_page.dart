import 'package:defense_game/component/game_rect_button.dart';
import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:defense_game/funtion/game_function.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GameOverPage extends PositionComponent {
  GameOverPage({super.key});

  @override
  void onLoad() async {
    super.onLoad();
    SpriteComponent spriteComponent = SpriteComponent();
    Sprite sprite = await Sprite.load("game_over.png");
    spriteComponent.sprite = sprite;
    spriteComponent.size = Vector2(1080, 1920);
    spriteComponent.anchor = Anchor.center;
    add(spriteComponent);

    GameRectButton buttonComponent = GameRectButton(
      spriteFileName: "white_button.png",
      buttonSize: Vector2(800, 200),
      textComponent: TextComponent(
        text: '타이틀로 돌아가기',
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: GameFunction().getTextStyle(
            fontSize: 60,
            color: Colors.indigo,
          ),
        ),
      ),
      onTapUpEvent: () {
        EventBus().fire(ChangePageEvent(pageType: PageType.title));
      },
    );
    buttonComponent.position = Vector2(0, 700);
    add(buttonComponent);
  }
}
