import 'package:flame/components.dart';

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
  final List<PositionComponent> components;
  CollideEvent({required this.components});
}

enum EnemyType {
  normal,
}

class EnemyDamageEvent {
  final int damage;
  final int uniqueId;
  final EnemyType enemyType;
  EnemyDamageEvent({
    required this.damage,
    required this.uniqueId,
    required this.enemyType,
  });
}

class EnemyDeactivateEvent {
  final int uniqueId;
  EnemyDeactivateEvent({required this.uniqueId});
}

class GameItemDamageEvent {
  final PositionComponent gameItem;
  final int damage;
  GameItemDamageEvent({required this.gameItem, required this.damage});
}

enum GameItemType {
  powerUp,
  speedUp,
  health,
}

class GameItemDeactivateEvent {
  final GameItemType gameItemType;
  final double itemValue;
  GameItemDeactivateEvent(
      {required this.gameItemType, required this.itemValue});
}
