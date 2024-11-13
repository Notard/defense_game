import 'dart:async';

import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:defense_game/game/bullet.dart';
import 'package:defense_game/game/enemy.dart';
import 'package:flame/components.dart';

class BulletPool extends PositionComponent {
  final int initialSize;

  int _damage = 3;
  double _radius = 50;
  bool _isPenetrate = false;

  final Map<int, Bullet> _activeBullets = {};
  final Map<int, Bullet> _inactiveBullets = {};

  BulletPool({required this.initialSize});

  StreamSubscription<BulletTypeEvent>? bulletTypeSubscription;
  StreamSubscription<BulletFireEvent>? fireBulletSubscription;
  StreamSubscription<BulletDeactivateEvent>? bulletDeactivateSubscription;
  StreamSubscription<GameItemDeactivateEvent>? gameItemDeactivateSubscription;
  //구독 변수
  StreamSubscription<CollideEvent>? collideSubscription;

  @override
  void onLoad() async {
    super.onLoad();
    Sprite bulletSprite = await Sprite.load('bullet_silver.png');
    for (int i = 0; i < initialSize; i++) {
      Bullet bullet = Bullet(index: i);
      bullet.setSprite(bulletSprite);
      add(bullet);
      _inactiveBullets[i] = bullet;
    }

    bulletTypeSubscription = EventBus().on<BulletTypeEvent>(onBulletTypeEvent);
    fireBulletSubscription = EventBus().on<BulletFireEvent>(onFireBulletEvent);
    bulletDeactivateSubscription =
        EventBus().on<BulletDeactivateEvent>(onBulletDeactivateEvent);
    // 이벤트 구독
    collideSubscription = EventBus().on<CollideEvent>(onCollideEvent);
    gameItemDeactivateSubscription =
        EventBus().on<GameItemDeactivateEvent>(onGameItemDeactivateEvent);
  }

  void onBulletTypeEvent(BulletTypeEvent event) {
    _damage = event.damage;
    _radius = event.radius;
    _isPenetrate = event.isPenetrate;
  }

  void onFireBulletEvent(BulletFireEvent event) {
    fire(event.position, event.velocity);
  }

  void onBulletDeactivateEvent(BulletDeactivateEvent event) {
    Bullet? bullet = _activeBullets.remove(event.index);
    if (bullet != null) {
      _inactiveBullets[event.index] = bullet;
    }
  }

  // 이벤트 처리
  void onCollideEvent(CollideEvent event) {
    List<Enemy> enemies = event.components.whereType<Enemy>().toList();
    for (Enemy enemy in enemies) {
      collision(enemy);
    }
  }

  void onGameItemDeactivateEvent(GameItemDeactivateEvent event) {
    if (event.gameItemType == GameItemType.powerUp) {
      _damage += event.itemValue.toInt();
    }
  }

  void fire(Vector2 position, Vector2 velocity) {
    if (_inactiveBullets.isNotEmpty) {
      int index = _inactiveBullets.keys.first;
      Bullet bullet = _inactiveBullets.remove(index)!;
      bullet.fire(position, velocity, _damage, _radius, _isPenetrate);
      _activeBullets[index] = bullet;
    }
  }

  // 충돌 처리
  void collision(Enemy enemy) {
    for (Bullet bullet in _activeBullets.values) {
      bullet.collideWith(enemy);
    }
  }

  @override
  void onRemove() {
    bulletTypeSubscription?.cancel();
    fireBulletSubscription?.cancel();
    bulletDeactivateSubscription?.cancel();
    collideSubscription?.cancel();
    gameItemDeactivateSubscription?.cancel();
    super.onRemove();
  }
}
