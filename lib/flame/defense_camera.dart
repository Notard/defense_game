import 'package:flame/camera.dart';
import 'package:flame/components.dart';

class DefenseCamera extends CameraComponent {
  DefenseCamera() {
    viewport = FixedResolutionViewport(
      resolution: Vector2(1080, 1920),
    );
  }
  @override
  void onLoad() async {
    super.onLoad();
  }
}
