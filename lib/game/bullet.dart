import 'dart:ui';
import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:defense_game/game/enemy.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

class Bullet extends PositionComponent {
  bool _isActive = false;
  bool get isActive => _isActive;
  Sprite? _sprite;
  Vector2 _velocity = Vector2.zero();
  int _damage = 0;
  int get damage => _damage;
  final Vector2 screenSize = Vector2(1080, 1920);
  double _radius = 50;
  //관통
  bool _isPenetrate = false;
  final int index;

  Bullet({required this.index});

  @override
  void onLoad() async {
    super.onLoad();
    deactivate(); // 활성화 여부
  }

  void setSprite(Sprite sprite) {
    _sprite = sprite;
    SpriteComponent spriteComponent = SpriteComponent(
      sprite: _sprite,
      size: Vector2(20, 50),
    );
    add(spriteComponent);
  }

  void fire(Vector2 position, Vector2 velocity, int damage, double radius,
      bool isPenetrate) {
    // 활성화
    activate();
    this.position = position;
    _velocity = velocity;
    _damage = damage;
    _radius = radius;
    _isPenetrate = isPenetrate;
  }

  void activate() {
    _isActive = true;
  }

  void deactivate() {
    _isActive = false;
    position = Vector2(-10000, -10000);
    EventBus().fire(BulletDeactivateEvent(index: index));
  }

  // 화면을 벗어났는지 체크
  bool isOutOfBounds() {
    return position.x < -screenSize.x / 2 ||
        position.x > screenSize.x / 2 ||
        position.y < -screenSize.y / 2 ||
        position.y > screenSize.y / 2;
  }

  // 충돌 처리
  int collideWith(Enemy enemy) {
    Circle bulletCircle = Circle(position, _radius);
    Circle enemyCircle = Circle(enemy.position, enemy.size.x / 2);

    if (checkCollision(bulletCircle, enemyCircle)) {
      if (!_isPenetrate) {
        deactivate();
      }
      EventBus().fire(EnemyDamageEvent(
        damage: _damage,
        uniqueId: enemy.uniqueId,
        enemyType: enemy.enemyType,
      ));
      return damage;
    }
    return 0;
  }

  // 충돌 체크
  bool checkCollision(Circle c1, Circle c2) {
    double distanceSquared = (c1.center - c2.center).length2;
    double radiusSum = c1.radius + c2.radius;
    return distanceSquared <= radiusSum * radiusSum;
  }

  @override
  void update(double dt) {
    if (!isActive) {
      return;
    }
    super.update(dt);
    position += _velocity * dt;

    // 화면 밖으로 나갔을 때 비활성화
    if (isOutOfBounds()) {
      deactivate();
    }
  }

  @override
  void render(Canvas canvas) {
    // 활성화 여부에 따라 렌더링 여부 결정
    if (!isActive) {
      return;
    }
    super.render(canvas);
  }
}
