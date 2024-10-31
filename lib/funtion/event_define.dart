import 'package:defense_game/game/bullet.dart';
import 'package:defense_game/game/enemy.dart';
import 'package:flame/components.dart';
import 'package:flame/src/game/notifying_vector2.dart';

enum PageType {
  title,
  main,
  game,
}

class ChangePageEvent {
  final PageType pageType;
  ChangePageEvent({required this.pageType});
}

class PanMoveEvent {
  final double moveX;
  PanMoveEvent({required this.moveX});
}

class BulletTypeEvent {
  final int damage;
  final double radius;
  final bool isPenetrate;
  BulletTypeEvent({
    required this.damage,
    required this.radius,
    required this.isPenetrate,
  });
}

class BulletFireEvent {
  final Vector2 position;
  final Vector2 velocity;
  BulletFireEvent({required this.position, required this.velocity});
}

class BulletDeactivateEvent {
  final int index;
  BulletDeactivateEvent({required this.index});
}

class FireIntervalEvent {
  final double interval;
  FireIntervalEvent({required this.interval});
}

class CollideEvent {
  final List<Enemy> enemies;
  CollideEvent({required this.enemies});
}

class EnemyDamageEvent {
  final int damage;
  final int uniqueId;
  EnemyDamageEvent({required this.damage, required this.uniqueId});
}
