import 'package:defense_game/game/bullet_pool.dart';
import 'package:defense_game/game/cloud.dart';
import 'package:defense_game/game/collision_manager.dart';
import 'package:defense_game/game/enemy_manager.dart';
import 'package:defense_game/game/game_item_pool.dart';
import 'package:defense_game/game/my_ship.dart';
import 'package:flame/components.dart';

import 'game_background.dart';

class GamePage extends PositionComponent {
  GamePage({super.key});

  SpriteComponent? background;
  final List<SpriteComponent>? clouds = [];

  @override
  void onLoad() async {
    GameBackground gameBackground = GameBackground();
    gameBackground.priority = 0;
    add(gameBackground);
    CloudSpawner cloudSpawner = CloudSpawner();
    cloudSpawner.priority = 1;
    add(cloudSpawner);

    MyShip myShip = MyShip();
    myShip.priority = 3;
    add(myShip);

    BulletPool bulletPool = BulletPool();
    bulletPool.priority = 2;
    add(bulletPool);

    EnemyManager enemyManager = EnemyManager();
    enemyManager.priority = 3;
    add(enemyManager);

    GameItemPool gameItemPool = GameItemPool();
    gameItemPool.priority = 4;
    add(gameItemPool);

    CollisionManager collisionManager = CollisionManager();
    collisionManager.priority = 5;
    add(collisionManager);
  }
}
