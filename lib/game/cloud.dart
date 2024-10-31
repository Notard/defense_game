import 'dart:math';
import 'package:flame/components.dart';

class CloudSpawner extends PositionComponent {
  double spawnTimer = 0;
  double spawnInterval = 0.0;
  final double screenWidth = 1080;

  final Random _random = Random();
  final List<String> cloudImages = [
    'cloud1.png',
    'cloud2.png',
    'cloud3.png',
    'cloud4.png',
    'cloud5.png',
  ];
  final List<Sprite> cloudSprites = [];

  @override
  void onLoad() async {
    for (var cloud in cloudImages) {
      cloudSprites.add(await Sprite.load(cloud));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    spawnTimer += dt;

    if (spawnTimer >= spawnInterval) {
      spawnCloud();
      spawnTimer = 0;
      spawnInterval = _random.nextDouble() * 2 + 5;
    }
  }

  void spawnCloud() {
    final cloudType = cloudImages[_random.nextInt(5)];
    final randomX = _random.nextDouble() * screenWidth - (screenWidth / 2);
    final cloud = Cloud(
        cloudType: cloudType,
        x: randomX,
        sprite: cloudSprites[_random.nextInt(5)]);
    add(cloud);
  }
}

class Cloud extends SpriteComponent {
  double speed = 0;
  final double screenHeight = 1920;

  Cloud({required String cloudType, required double x, required Sprite sprite})
      : super(size: Vector2(300, 150)) {
    this.sprite = sprite;
    anchor = Anchor.center;
    speed = Random().nextDouble() * 10 + 50;
    position = Vector2(x, -screenHeight / 2 - 150);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt; // y축으로 구름을 아래로 이동
    if (position.y > screenHeight) {
      removeFromParent();
    }
  }
}
