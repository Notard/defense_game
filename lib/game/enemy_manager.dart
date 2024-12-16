import 'dart:async';
import 'dart:math';

import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:defense_game/game/enemy.dart';
import 'package:flame/components.dart';

class EnemyManager extends Component with HasGameRef {
  double spawnTimer = 0;
  double spawnInterval = 3;
  Random random = Random();
  List<Enemy> enemies = [];
  int enemyCount = 0;
  int nowMaxHp = 10;
  double hpUpdateTimer = 0;
  StreamSubscription<EnemyDamageEvent>? enemyDamageSubscription;

  @override
  void onLoad() async {
    await gameRef.images.load('enemy_01.png');
    enemyDamageSubscription =
        EventBus().on<EnemyDamageEvent>(onEnemyDamageEvent);
    EventBus().fire(ActivateEnemyListEvent(enemies: enemies));

    super.onLoad();
  }

  void onEnemyDamageEvent(EnemyDamageEvent event) {
    if (enemies.isEmpty) {
      return;
    }
    if (enemies.any((enemy) => enemy.uniqueId == event.enemyID) == false) {
      return;
    }
    Enemy enemy =
        enemies.firstWhere((enemy) => enemy.uniqueId == event.enemyID);
    enemy.damaged(event.damage);
    if (enemy.hp <= 0) {
      enemies.remove(enemy);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    spawnTimer += dt;
    if (spawnTimer >= spawnInterval) {
      spawnEnemy();
      spawnTimer = 0;
    }
    hpUpdateTimer += dt;
    if (hpUpdateTimer >= 10) {
      nowMaxHp += 4;
      hpUpdateTimer = 0;
    }
  }

  void spawnEnemy() {
    double randomX =
        (random.nextDouble() * gameRef.size.x) - (gameRef.size.x / 2);
    double spawnY = -(gameRef.size.y / 2);

    Enemy enemy = Enemy(
        uniqueId: enemyCount,
        maxHp: nowMaxHp,
        speed: 100,
        damage: 1,
        imageName: 'enemy_01.png',
        position: Vector2(randomX, spawnY));
    add(enemy);
    enemyCount++;
    enemies.add(enemy);
  }

  @override
  void onRemove() {
    enemyDamageSubscription?.cancel();
    super.onRemove();
  }
}
