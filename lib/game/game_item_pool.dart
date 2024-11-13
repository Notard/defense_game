import 'dart:async';
import 'dart:math';

import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:defense_game/game/game_item.dart';
import 'package:flame/components.dart';

class GameItemPool extends PositionComponent {
  GameItem? _gameItem1;
  GameItem? _gameItem2;
  DateTime? _lastDamageTime;
  int _makeItemCount = 1;

  final List<PositionComponent> _gameItems = [];

  // 이벤트 구독 변수
  StreamSubscription<GameItemDamageEvent>? gameItemDamageSubscription;
  StreamSubscription<GameItemDeactivateEvent>? gameItemDeactivateSubscription;

  @override
  void onLoad() async {
    super.onLoad();
    _lastDamageTime = DateTime.now();
    gameItemDamageSubscription =
        EventBus().on<GameItemDamageEvent>(onGameItemDamageEvent);
    gameItemDeactivateSubscription =
        EventBus().on<GameItemDeactivateEvent>(onGameItemDeactivateEvent);
  }

  @override
  void onRemove() {
    super.onRemove();
    gameItemDamageSubscription?.cancel();
    gameItemDeactivateSubscription?.cancel();
  }

  void onGameItemDamageEvent(GameItemDamageEvent event) {
    PositionComponent gameItem = event.gameItem;
    if (gameItem == _gameItem1) {
      _gameItem1?.damaged(event.damage);
    } else if (gameItem == _gameItem2) {
      _gameItem2?.damaged(event.damage);
    }
  }

  void onGameItemDeactivateEvent(GameItemDeactivateEvent event) {
    removeAll(_gameItems);
    _gameItems.clear();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 10초마다 아이템 생성
    if (_lastDamageTime != null &&
        DateTime.now().difference(_lastDamageTime!).inSeconds > 10) {
      bool isDebuff = Random().nextBool();
      _lastDamageTime = DateTime.now();
      double xPos1 = -300;
      double xPos2 = 300;
      GameItemType randomType = GameItemType.values[Random().nextInt(3)];
      int hp = _makeItemCount * 10;
      _gameItem1 = GameItem(
        position: Vector2(xPos1, -960),
        type: randomType,
        maxHp: hp,
        isDebuff: isDebuff,
      );
      add(_gameItem1!);
      _gameItems.add(_gameItem1!);
      GameItemType randomType2 = GameItemType.values[Random().nextInt(3)];
      _gameItem2 = GameItem(
        position: Vector2(xPos2, -960),
        type: randomType2,
        maxHp: hp,
        isDebuff: !isDebuff,
      );
      add(_gameItem2!);
      _gameItems.add(_gameItem2!);
      _makeItemCount++;
    }
    // 충돌 처리
    if (_gameItems.isNotEmpty) {
      EventBus().fire(CollideEvent(components: _gameItems));
    }
  }
}
