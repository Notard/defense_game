import 'dart:math';

import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:defense_game/game/game_item.dart';
import 'package:flame/components.dart';

class GameItemPool extends PositionComponent with HasGameRef {
  DateTime? _lastDamageTime;
  int _makeItemCount = 1;

  @override
  void onLoad() async {
    super.onLoad();
    gameRef.images.loadAll(['power_item.png', 'speed_item.png']);
    _lastDamageTime = DateTime.now();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 10초마다 아이템 생성
    if (_lastDamageTime != null &&
        DateTime.now().difference(_lastDamageTime!).inSeconds > 10) {
      _lastDamageTime = DateTime.now();
      double xPos1 = Random().nextDouble() * 600 - 300;
      int randomTypeIndex = Random().nextInt(GameItemType.values.length);
      GameItemType randomType = GameItemType.values[randomTypeIndex];
      int hp = _makeItemCount * 10;
      double effectValue = randomType == GameItemType.powerUp
          ? 1 * _makeItemCount.toDouble()
          : 0.02;
      GameItem gameItem = GameItem(
        position: Vector2(xPos1, -960),
        type: randomType,
        maxHp: hp,
        effectValue: effectValue,
      );
      add(gameItem);

      EventBus().fire(GameItemActivateEvent(gameItem: gameItem));

      _makeItemCount++;
    }
  }
}
