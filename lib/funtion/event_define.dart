import 'package:flame/components.dart';

enum PageType {
  title,
  main,
  game,
  gameOver,
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
  BulletFireEvent({required this.position});
}

class BulletInactivateEvent {
  final int index;
  BulletInactivateEvent({required this.index});
}

class FireIntervalEvent {
  final double interval;
  FireIntervalEvent({required this.interval});
}

class CollideEvent {
  final List<PositionComponent> components;
  CollideEvent({required this.components});
}

// 활성화 한 총알 리스트
class ActivateBulletListEvent {
  final List<PositionComponent> bullets;
  ActivateBulletListEvent({required this.bullets});
}

// 활성화 한 적 리스트
class ActivateEnemyListEvent {
  final List<PositionComponent> enemies;
  ActivateEnemyListEvent({required this.enemies});
}

enum EnemyType {
  normal,
}

class EnemyDamageEvent {
  final int damage;
  final int enemyID;
  final int bulletID;

  EnemyDamageEvent({
    required this.damage,
    required this.enemyID,
    required this.bulletID,
  });
}

class EnemyDeactivateEvent {
  final int uniqueId;
  EnemyDeactivateEvent({required this.uniqueId});
}

enum GameItemType {
  powerUp,
  speedUp,
}

class GameItemInactivateEvent {
  final GameItemType gameItemType;
  final double itemValue;

  GameItemInactivateEvent(
      {required this.gameItemType, required this.itemValue});
}

class GameItemActivateEvent {
  final PositionComponent gameItem;
  GameItemActivateEvent({required this.gameItem});
}
