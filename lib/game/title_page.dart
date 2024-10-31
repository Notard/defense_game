import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class TitlePage extends PositionComponent {
  TitlePage({super.key});

  @override
  void onLoad() async {
    //title_back.png
    SpriteComponent title =
        SpriteComponent(sprite: await Sprite.load('title_back.png'));
    title.position = Vector2(0, 0);
    title.anchor = Anchor.center;
    title.size = Vector2(1080, 1920);
    title.opacity = 0;
    add(title);
    fadeIn(title);
  }

  void fadeIn(PositionComponent component) {
    OpacityEffect fadeIn = OpacityEffect.to(
      1.0,
      EffectController(duration: 0.3),
    );
    component.add(fadeIn);
    OpacityEffect fadeOut = OpacityEffect.to(
      0.0,
      DelayedEffectController(
        delay: 0.1,
        EffectController(duration: 0.3),
      ),
    );
    SequenceEffect fadeInOutSequence = SequenceEffect([fadeIn, fadeOut]);
    component.add(fadeInOutSequence);

    fadeInOutSequence.onComplete = () {
      removeFromParent();
      EventBus().fire(ChangePageEvent(pageType: PageType.main));
    };
  }
}
