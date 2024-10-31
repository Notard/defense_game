import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class DefenseFrame extends FlameGame with PanDetector {
  DefenseFrame({required super.world, required super.camera});
  @override
  void onLoad() async {
    super.onLoad();
  }

  Vector2 startPos = Vector2(0, 0);

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // 스와이프 중
    Vector2 nowPos = info.eventPosition.global;
    Vector2 diff = nowPos - startPos;
    Vector2 windowSize = camera.viewport.size;
    diff.x = diff.x * (1080 / windowSize.x);
    EventBus().fire(PanMoveEvent(moveX: diff.x));
    startPos = nowPos;
  }

  @override
  void onPanStart(DragStartInfo info) {
    // 스와이프 시작
    startPos = info.eventPosition.global;
  }
}
