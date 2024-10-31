import 'package:flame/components.dart';

class GuITimerComponent extends PositionComponent {
  final Map<String, Sprite?> _numberSprites = {};
  SpriteComponent? dotImageComponent;
  PositionComponent? numberComponent;
  double _preTime = 0.0;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await loadImages();
  }

  Future<void> loadImages() async {
    for (int i = 0; i <= 9; i++) {
      Sprite sprite = await Sprite.load('$i.png');
      _numberSprites[i.toString()] = sprite;
    }
    _numberSprites['.'] = await Sprite.load('dot.png');
  }

  void renderNumber(double time) async {
    if (time.toStringAsFixed(1) == _preTime.toStringAsFixed(1)) {
      // 소수점 한자리까지 같은 경우 교체하지 않는다.
      return;
    }

    _preTime = time;
    numberComponent?.removeFromParent();
    numberComponent = PositionComponent();
    add(numberComponent!);
    String timeString = time.toStringAsFixed(1);
    List<String> timeStringList = timeString.split('');
    double x = 0;
    for (String number in timeStringList) {
      Sprite? sprite = _numberSprites[number];
      if (sprite != null) {
        SpriteComponent spriteComponent = SpriteComponent(sprite: sprite);
        spriteComponent.x = x;

        if (number == '.') {
          spriteComponent.size = Vector2(30, 30);
          spriteComponent.y = 50;
        } else {
          spriteComponent.size = Vector2(70, 70);
          spriteComponent.y = 0;
        }

        spriteComponent.setOpacity(1);
        x += spriteComponent.size.x;
        numberComponent?.add(spriteComponent);
      }
    }
  }
}
