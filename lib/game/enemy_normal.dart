// enemy 상속
import 'package:defense_game/game/enemy.dart';
import 'package:flame/components.dart';

class EnemyNormal extends Enemy {
  EnemyNormal({
    required super.myShip,
    required super.uniqueId,
    super.position,
  });

  @override
  void onLoad() {
    super.onLoad();
    speed = 2;
    hp = 10;
    damage = 1;
    loadImage('enemy_01.png');
  }

  @override
  Future<void> loadImage(String imageName) async {
    size = Vector2(100, 150);
    Sprite sprite = await Sprite.load(imageName);
    SpriteComponent spriteComponent = SpriteComponent(
      sprite: sprite,
      size: size,
    );

    add(spriteComponent);
  }

  @override
  void move() {
    super.move();
    Vector2 shipPosition = myShip.position;
    Vector2 distance = shipPosition - position;
    double distanceLength = distance.length;
    if (distanceLength < 10) {
      attack();
    }
  }

  @override
  void attack() {
    myShip.damaged(damage);
    damaged(hp);
  }
}
