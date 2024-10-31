import 'package:flame/components.dart';

class GameBackgroundSprite extends PositionComponent {
  double scrollSpeed = 300;
  double _spriteHeight = 0;
  double get spriteHeight => _spriteHeight;
  double spriteWidth = 0;
  final String spriteName;
  final bool isVerticalFlip;
  SpriteComponent? spriteComponent;
  GameBackgroundSprite(
      {super.key, required this.spriteName, required this.isVerticalFlip});

  Future<void> loadSprite() async {
    Sprite sprite = await Sprite.load(spriteName);
    _spriteHeight = sprite.image.height.toDouble();
    spriteWidth = sprite.image.width.toDouble();
    // 비율 계산
    // 가로를 1080으로 맞추기
    _spriteHeight = _spriteHeight / spriteWidth * 1080;
    spriteWidth = 1080;
    spriteComponent = SpriteComponent()
      ..sprite = sprite
      ..size = Vector2(spriteWidth, _spriteHeight)
      ..anchor = Anchor.bottomCenter;
    if (isVerticalFlip) {
      spriteComponent!.flipVerticallyAroundCenter();
    }
    add(spriteComponent!);
  }
}

class GameBackground extends PositionComponent {
  GameBackground({super.key});
  double scrollSpeed = 3;
  GameBackgroundSprite? background1;
  GameBackgroundSprite? background2;
  double spriteHeight = 0;
  double spriteWidth = 0;

  @override
  void onLoad() async {
    background1 = GameBackgroundSprite(
        spriteName: 'game_back.png', isVerticalFlip: false);
    background2 =
        GameBackgroundSprite(spriteName: 'game_back.png', isVerticalFlip: true);
    await background1?.loadSprite();
    await background2?.loadSprite();

    background1?.position = Vector2(0, 960);
    background2?.position = Vector2(0, -background2!.spriteHeight + 960);

    add(background1!);
    add(background2!);
  }

  @override
  void update(double dt) {
    // 배경 이동
    if (background1 == null) {
      return;
    }
    background1?.position.y += scrollSpeed * dt;
    if (background2 == null) {
      return;
    }
    background2?.position.y += scrollSpeed * dt;

    if (background1!.spriteHeight == 0) {
      return;
    }

    double backgroundHeight = background1!.spriteHeight + 960;

    // // 화면 아래로 완전히 사라지면 다시 위로 이동
    if (background1!.position.y >= backgroundHeight) {
      background1!.position.y = -backgroundHeight + 1920;
    }

    if (background2!.position.y >= backgroundHeight) {
      background2!.position.y = -backgroundHeight + 1920;
    }
  }
}
