import 'dart:async';

import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:flame/components.dart';

class MyShip extends PositionComponent {
  Timer? _fireTimer;
  StreamSubscription<PanMoveEvent>? panMoveSubscription;
  StreamSubscription<FireIntervalEvent>? fireIntervalSubscription;
  StreamSubscription<GameItemDeactivateEvent>? gameItemDeactivateSubscription;
  double _fireInterval = 0.5;
  DateTime _lastFireTime = DateTime.now();
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
    gameItemDeactivateSubscription =
        EventBus().on<GameItemDeactivateEvent>(onGameItemDeactivateEvent);
  }

  @override
  void onRemove() {
    panMoveSubscription?.cancel();
    fireIntervalSubscription?.cancel();
    gameItemDeactivateSubscription?.cancel();
    super.onRemove();
    _fireTimer?.stop();
  }

  void onPanMoveEvent(PanMoveEvent event) {
    position.x += event.moveX;
    position.x = position.x.clamp(-540, 540);
  }

  void _onFireTimerTick() {
    EventBus()
        .fire(BulletFireEvent(position: position, velocity: Vector2(0, -900)));
  }

  void onFireIntervalEvent(FireIntervalEvent event) {
    _fireInterval = event.interval;
  }

  void onGameItemDeactivateEvent(GameItemDeactivateEvent event) {
    if (event.gameItemType == GameItemType.health) {
      _hp += event.itemValue.toInt();
    } else if (event.gameItemType == GameItemType.speedUp) {
      _fireInterval -= event.itemValue;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    DateTime now = DateTime.now();
    if (now.difference(_lastFireTime).inMilliseconds >= _fireInterval * 1000) {
      _onFireTimerTick();
      _lastFireTime = now;
    }
  }

  void damaged(int damage) {
    _hp -= damage;
  }
}
