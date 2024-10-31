import 'package:flame/components.dart';

class NumberDisplay extends PositionComponent {
  final Map<String, SpriteComponent?> _numberSprites = {};
  String score = '0';

  NumberDisplay({required Vector2 position}) : super(position: position);

  @override
  Future<void> onLoad() async {
    await loadImages();
    setScore(0);
  }

  Future<void> loadImages() async {
    for (int i = 0; i <= 9; i++) {
      Sprite sprite = await Sprite.load('$i.png');
      double aspectRatio = sprite.originalSize.x / sprite.originalSize.y;
      SpriteComponent scoreImageComponent = SpriteComponent(
        sprite: sprite,
        size: Vector2(70 * aspectRatio, 70),
      );
      _numberSprites[i.toString()] = scoreImageComponent;
      scoreImageComponent.setOpacity(0);
      add(scoreImageComponent);
    }
  }

  void setScore(int newScore) {
    //_numberSprites to all opacity 0
    _numberSprites.forEach((key, value) {
      value?.setOpacity(0);
    });
    score = newScore.toString();
    double xOffset = 0;
    for (int i = 0; i < score.length; i++) {
      String digit = score[i];
      _setScoreImage(digit, xOffset);
      xOffset += 60; // 숫자 간의 간격
    }
  }

  void _setScoreImage(String score, double offset) {
    SpriteComponent? scoreImageComponent = _numberSprites[score];
    // Sprite? sprite = _numberSprites[score];
    if (scoreImageComponent != null) {
      scoreImageComponent.position = Vector2(offset, 0);
      scoreImageComponent.setOpacity(1);
    }
  }
}
