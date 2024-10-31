import 'package:defense_game/game/my_ship.dart';
import 'package:flame/components.dart';

abstract class Enemy extends PositionComponent {
  int hp = 10;
  double speed = 1;
  final MyShip myShip;
  int damage = 1;
  bool isActive = false;
  int uniqueId;

  Enemy({
    required this.myShip,
    required this.uniqueId,
    super.position,
  });

  void damaged(int damage) {
    hp -= damage;
    if (hp <= 0) {
      isActive = false;
      position = Vector2(-10000, -10000);
    }
  }

  void setActive(bool active) {
    isActive = active;
  }

  @override
  void update(double dt) {
    if (isActive == true) {
      super.update(dt);
      move();
    }
  }

  @override
  void onRemove() {
    if (isActive == true) {
      super.onRemove();
    }
  }

  void move() {
    Vector2 target = myShip.position;
    Vector2 direction = target - position;
    Vector2 velocity = direction.normalized() * speed;
    position += velocity;
  }

  // 추상 메서드
  Future<void> loadImage(String imageName);
  void attack();
}
