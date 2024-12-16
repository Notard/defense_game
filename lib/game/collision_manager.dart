import 'dart:async';

import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:defense_game/game/bullet.dart';
import 'package:defense_game/game/enemy.dart';
import 'package:defense_game/game/game_item.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

class CollisionManager extends PositionComponent {
  List<PositionComponent> bullets = [];
  List<PositionComponent> enemies = [];
  PositionComponent? gameItem;

  Map<int, List<PositionComponent>> bulletGrid = {};
  Map<int, List<PositionComponent>> enemyGrid = {};

  double timeSinceLastUpdate = 0.0;
  final double updateInterval = 0.1;

  final int gridSize = 300; // 각 그리드 셀 크기

  StreamSubscription<ActivateBulletListEvent>? bulletSubscription;
  StreamSubscription<ActivateEnemyListEvent>? enemySubscription;
  StreamSubscription<GameItemActivateEvent>? gameItemSubscription;
  StreamSubscription<GameItemInactivateEvent>? gameItemInactivateSubscription;
  @override
  void onLoad() {
    super.onLoad();
    bulletSubscription =
        EventBus().on<ActivateBulletListEvent>(onActivateBulletListEvent);
    enemySubscription =
        EventBus().on<ActivateEnemyListEvent>(onActivateEnemyListEvent);
    gameItemSubscription =
        EventBus().on<GameItemActivateEvent>(onGameItemActivateEvent);
    gameItemInactivateSubscription =
        EventBus().on<GameItemInactivateEvent>(onGameItemInactivateEvent);
  }

  // 위치를 그리드 셀 인덱스로 변환
  int getCellIndex(Vector2 position) {
    int x = ((position.x) / gridSize).floor();
    int y = ((position.y) / gridSize).floor();
    return x + y * 10000; // 고유한 인덱스 계산
  }

  // 그리드 갱신
  void updateGrid(
    List<PositionComponent> components,
    Map<int, List<PositionComponent>> grid,
  ) {
    grid.clear();
    for (var component in components) {
      var cellIndex = getCellIndex(component.position);
      grid.putIfAbsent(cellIndex, () => []).add(component);
    }
  }

  void onActivateBulletListEvent(ActivateBulletListEvent event) {
    bullets = event.bullets;
  }

  void onActivateEnemyListEvent(ActivateEnemyListEvent event) {
    enemies = event.enemies;
  }

  void onGameItemActivateEvent(GameItemActivateEvent event) {
    gameItem = event.gameItem;
  }

  void onGameItemInactivateEvent(GameItemInactivateEvent event) {
    gameItem = null;
  }

  @override
  void update(double dt) {
    super.update(dt);
    timeSinceLastUpdate += dt;
    if (timeSinceLastUpdate > updateInterval) {
      updateGrid(bullets, bulletGrid);
      updateGrid(enemies, enemyGrid);

      timeSinceLastUpdate = 0.0;
    }

    // 충돌 검사
    for (PositionComponent bullet in bullets) {
      int bulletCell = getCellIndex(bullet.position);
      if (enemyGrid.containsKey(bulletCell) == true) {
        for (PositionComponent enemy in enemyGrid[bulletCell]!) {
          collideWith(bullet, enemy);
        }
      }
      if (gameItem != null) {
        Circle bulletCircle = Circle(bullet.position, bullet.size.x / 2);
        Circle gameItemCircle =
            Circle(gameItem!.position, gameItem!.size.x / 2);
        if (checkCollision(bulletCircle, gameItemCircle)) {
          Bullet colBullet = bullet as Bullet;
          GameItem colGameItem = gameItem! as GameItem;
          int hp = colGameItem.damaged(colBullet.damage);

          EventBus().fire(EnemyDamageEvent(
            damage: -100,
            enemyID: -100,
            bulletID: colBullet.index,
          ));
          if (hp <= 0) {
            gameItem = null;
          }
        }
      }
    }
  }

  // 충돌 처리
  void collideWith(PositionComponent bullet, PositionComponent enemy) {
    Circle bulletCircle = Circle(bullet.position, bullet.size.x / 2);
    Circle enemyCircle = Circle(enemy.position, enemy.size.x / 2);

    if (checkCollision(bulletCircle, enemyCircle)) {
      Bullet colBullet = bullet as Bullet;
      Enemy colEnemy = enemy as Enemy;
      int bulletID = colBullet.index;
      int enemyID = colEnemy.uniqueId;
      EventBus().fire(EnemyDamageEvent(
        damage: colBullet.damage,
        enemyID: enemyID,
        bulletID: bulletID,
      ));
    }
  }

  // 충돌 검사
  bool checkCollision(Circle c1, Circle c2) {
    double distanceSquared = (c1.center - c2.center).length2;
    double radiusSum = c1.radius + c2.radius;
    return distanceSquared <= radiusSum * radiusSum;
  }

  @override
  void onRemove() {
    bulletSubscription?.cancel();
    enemySubscription?.cancel();
    gameItemSubscription?.cancel();
    gameItemInactivateSubscription?.cancel();
    super.onRemove();
  }
}
