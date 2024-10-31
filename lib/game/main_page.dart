import 'dart:async';

import 'package:defense_game/component/game_rect_button.dart';
import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:defense_game/funtion/game_function.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class MainPage extends PositionComponent {
  MainPage({super.key});

  @override
  void onLoad() async {
    SpriteComponent background = SpriteComponent();
    background.sprite = await Sprite.load('main_back.png');
    background.size = Vector2(1080, 1920);
    background.position = Vector2(0, 0);
    background.anchor = Anchor.center;
    add(background);

    GameRectButton startButton = GameRectButton(
      spriteFileName: 'white_button.png',
      buttonSize: Vector2(540, 200),
      textComponent: TextComponent(
        text: '시작하기',
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: GameFunction().getTextStyle(
            fontSize: 60,
            color: Colors.indigo,
          ),
        ),
      ),
      onTapUpEvent: () {
        EventBus().fire(ChangePageEvent(pageType: PageType.game));
        removeFromParent();
      },
    );
    startButton.position = Vector2(0, 600);
    startButton.anchor = Anchor.center;
    add(startButton);

    TextComponent title = TextComponent(
      text: '디펜스 게임',
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: GameFunction().getTextStyle(
          fontSize: 160,
          color: Colors.blue,
        ),
      ),
    );
    title.position = Vector2(0, -400);
    add(title);
  }
}
