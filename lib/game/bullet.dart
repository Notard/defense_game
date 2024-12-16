import 'dart:ui';
import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:flame/components.dart';

class Bullet extends PositionComponent with HasGameRef {
  bool _isActive = true;
  bool get isActive => _isActive;
  final Vector2 velocity = Vector2(0, -1);
  final double speed = 1000;

  int _damage = 0;
  int get damage => _damage;
  final int index;
  Bullet({required this.index});
  @override
  void onLoad() async {
    super.onLoad();
    size = Vector2(50, 50);
    setSprite();
    inactivate();
    anchor = Anchor.center;
  }

  void setSprite() {
    Sprite sprite = Sprite(gameRef.images.fromCache('bullet_silver.png'));
    SpriteComponent spriteComponent = SpriteComponent(
      sprite: sprite,
      size: Vector2(20, 50),
    );
    add(spriteComponent);
  }

  void inactivate() {
    if (_isActive == true) {
      EventBus().fire(BulletInactivateEvent(index: index));
      _isActive = false;
      position = Vector2(-10000, -10000);
    }
  }

  void activate(Vector2 position, int damage) {
    _isActive = true;
    _damage = damage;
    this.position = position;
  }

  @override
  void update(double dt) {
    if (!isActive) {
      return;
    }
    super.update(dt);
    position += velocity * dt * speed;
    if (position.y < -gameRef.size.y / 2) {
      inactivate();
    }
  }

  @override
  void render(Canvas canvas) {
    if (!isActive) {
      return;
    }
    super.render(canvas);
  }
}
