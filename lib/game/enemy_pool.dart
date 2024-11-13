import 'dart:async';
import 'dart:math';

import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:defense_game/game/enemy.dart';
import 'package:defense_game/game/enemy_normal.dart';
import 'package:defense_game/game/my_ship.dart';
import 'package:flame/components.dart';
import 'package:collection/collection.dart';

class EnemyPool extends PositionComponent {
  EnemyPool({required this.myShip});
  final Map<EnemyType, List<Enemy>> activeEnemies = {};
  final Map<EnemyType, List<Enemy>> inactiveEnemies = {};
  final MyShip myShip;
  final double spawnInterval = 5;
  final double screenWidth = 1080;
  final double screenHeight = 1920;
  double spawnTimer = 0;

  // 이벤트 구독 변수
  StreamSubscription<EnemyDamageEvent>? enemyDamageSubscription;

  @override
  void onLoad() {
    super.onLoad();
    inactiveEnemies[EnemyType.normal] = [];
    activeEnemies[EnemyType.normal] = [];
    for (var i = 0; i < 1000; i++) {
      inactiveEnemies[EnemyType.normal]!.add(EnemyNormal(
        myShip: myShip,
        uniqueId: i,
        enemyType: EnemyType.normal,
        position: Vector2(-10000, -10000),
      ));
    }
    // 이벤트 구독
    enemyDamageSubscription =
        EventBus().on<EnemyDamageEvent>(onEnemyDamageEvent);
  }

  // 이벤트 처리
  void onEnemyDamageEvent(EnemyDamageEvent event) {
    for (EnemyType enemyType in activeEnemies.keys) {
      Enemy? enemyToDamage = activeEnemies[enemyType]!
          .firstWhereOrNull((enemy) => enemy.uniqueId == event.uniqueId);
      if (enemyToDamage != null) {
        enemyToDamage.damaged(event.damage);
      }
    }
  }

  void spawnEnemy() {
    if (inactiveEnemies[EnemyType.normal]!.isEmpty) {
      return;
    }
    Enemy enemy = inactiveEnemies[EnemyType.normal]!.removeAt(0);
    add(enemy);
    enemy.setActive(true);
    // screenWidth 의 절반 위치에 생성
    Random random = Random();
    double randomX =
        -(screenWidth / 2) + (random.nextDouble() * screenWidth / 2);
    double randomY = -(screenHeight / 2);
    enemy.position = Vector2(randomX, randomY);
    activeEnemies[EnemyType.normal]!.add(enemy);
  }

  @override
  void update(double dt) {
    super.update(dt);
    spawnTimer += dt;
    if (spawnTimer >= spawnInterval) {
      spawnEnemy();
      spawnTimer = 0;
    }
    List<Enemy> enemies = [];
    for (EnemyType enemyType in activeEnemies.keys) {
      enemies.addAll(activeEnemies[enemyType]!);
    }
    EventBus().fire(CollideEvent(components: enemies));
  }

  // 구독 해제
  @override
  void onRemove() {
    super.onRemove();
    enemyDamageSubscription?.cancel();
  }
}
