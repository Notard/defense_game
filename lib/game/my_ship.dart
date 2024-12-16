import 'dart:async';

import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:flame/components.dart';

class MyShip extends PositionComponent {
  // Timer? _fireTimer;
  StreamSubscription<PanMoveEvent>? panMoveSubscription;
  StreamSubscription<FireIntervalEvent>? fireIntervalSubscription;
  StreamSubscription<GameItemInactivateEvent>? gameItemInactivateSubscription;
  double _fireInterval = 0.5;
  double _fireTime = 0;

  int _hp = 10;

  @override
  void onLoad() async {
    Sprite sprite = await Sprite.load('my_ship.png');
    SpriteComponent ship = SpriteComponent(
      sprite: sprite,
      size: Vector2(300, 300),
      anchor: Anchor.center,
    );

    add(ship);
    position = Vector2(0, 800);

    panMoveSubscription = EventBus().on<PanMoveEvent>(onPanMoveEvent);
    fireIntervalSubscription =
        EventBus().on<FireIntervalEvent>(onFireIntervalEvent);
    gameItemInactivateSubscription =
        EventBus().on<GameItemInactivateEvent>(onGameItemInactivateEvent);
  }

  @override
  void onRemove() {
    panMoveSubscription?.cancel();
    fireIntervalSubscription?.cancel();
    gameItemInactivateSubscription?.cancel();
    super.onRemove();
  }

  void onPanMoveEvent(PanMoveEvent event) {
    position.x += event.moveX;
    position.x = position.x.clamp(-540, 540);
  }

  void onFireIntervalEvent(FireIntervalEvent event) {
    _fireInterval = event.interval;
  }

  void onGameItemInactivateEvent(GameItemInactivateEvent event) {
    if (event.gameItemType == GameItemType.speedUp) {
      _fireInterval -= event.itemValue;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _fireTime += dt;
    if (_fireTime >= _fireInterval) {
      EventBus().fire(BulletFireEvent(position: position));
      _fireTime = 0;
    }
  }

  void damaged(int damage) {
    _hp -= damage;
  }
}
