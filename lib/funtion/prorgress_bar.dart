import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ProgressBar extends PositionComponent {
  double progress = 1.0; // 진행 상태 (0.0 ~ 1.0)
  final Color backgroundColor;
  final Color foregroundColor;

  Paint? _borderPaint;
  Paint? _backgroundPaint;
  Paint? _foregroundPaint;

  ProgressBar({
    required this.backgroundColor,
    required this.foregroundColor,
    required super.size,
    super.position,
  });

  @override
  void onLoad() {
    super.onLoad();
    _borderPaint = Paint();
    _borderPaint!.color = Colors.black;
    _borderPaint!.style = PaintingStyle.stroke;
    _borderPaint!.strokeWidth = 2;

    _backgroundPaint = Paint();
    _backgroundPaint!.color = backgroundColor;

    _foregroundPaint = Paint();
    _foregroundPaint!.color = foregroundColor;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // 배경 그리기
    canvas.drawRect(size.toRect(), _backgroundPaint!);

    // 전경 그리기
    final progressRect = Rect.fromLTWH(
      0,
      0,
      size.x * progress,
      size.y,
    );
    canvas.drawRect(progressRect, _foregroundPaint!);

    // 경계선 그리기
    canvas.drawRect(size.toRect(), _borderPaint!);
  }

  void setProgress(double progress) {
    this.progress = progress;
  }
}
