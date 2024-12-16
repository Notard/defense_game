import 'dart:async';
import 'dart:collection';

import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:defense_game/game/bullet.dart';
import 'package:flame/components.dart';

class BulletPool extends PositionComponent with HasGameRef {
  final Queue<Bullet> _inactiveBullets = Queue<Bullet>(); // 비활성화된 총알 (Queue)
  final Map<int, Bullet> _activeBullets = {}; // 활성화된 총알 (Map)
  final List<Bullet> _activeBulletsList = []; // 활성화된 총알 (List)
  StreamSubscription<BulletFireEvent>? bulletFireSubscription;
  StreamSubscription<EnemyDamageEvent>? enemyDamageSubscription;
  StreamSubscription<BulletInactivateEvent>? bulletInactivateSubscription;
  StreamSubscription<GameItemInactivateEvent>? gameItemInactivateSubscription;

  int damage = 3;

  @override
  void onLoad() async {
    await gameRef.images.load('bullet_silver.png');
    loadBullet();
    bulletFireSubscription = EventBus().on<BulletFireEvent>(onBulletFireEvent);
    enemyDamageSubscription =
        EventBus().on<EnemyDamageEvent>(onEnemyDamageEvent);
    bulletInactivateSubscription =
        EventBus().on<BulletInactivateEvent>(onBulletInactivateEvent);

    gameItemInactivateSubscription =
        EventBus().on<GameItemInactivateEvent>(onGameItemInactivateEvent);
    damage = 3;
    _activeBulletsList.addAll(_activeBullets.values);

    EventBus().fire(ActivateBulletListEvent(bullets: _activeBulletsList));

    super.onLoad();
  }

  void onGameItemInactivateEvent(GameItemInactivateEvent event) {
    if (event.gameItemType == GameItemType.powerUp) {
      damage++;
    }
  }

  // 총알 로드
  void loadBullet() {
    for (int i = 1; i < 100; i++) {
      Bullet bullet = Bullet(index: i);
      bullet.inactivate();
      add(bullet);
      _inactiveBullets.addLast(bullet); // 비활성화 큐에 추가
    }
  }

  // BulletFireEvent 처리: 총알 발사
  void onBulletFireEvent(BulletFireEvent event) {
    fire(event.position);
  }

  // EnemyDamageEvent 처리: 총알 비활성화
  void onEnemyDamageEvent(EnemyDamageEvent event) {
    inactivate(event.bulletID);
  }

  // BulletInactivateEvent 처리: 총알 비활성화
  void onBulletInactivateEvent(BulletInactivateEvent event) {
    inactivate(event.index);
  }

  // 총알 발사
  void fire(Vector2 position) {
    if (_inactiveBullets.isNotEmpty) {
      Bullet bullet = _inactiveBullets.removeFirst(); // 비활성화 큐에서 꺼냄
      bullet.activate(position, damage); // 총알 활성화
      _activeBullets[bullet.index] = bullet; // 활성화 Map에 추가
      _activeBulletsList.clear();
      _activeBulletsList.addAll(_activeBullets.values);
    }
  }

  // 총알 비활성화
  void inactivate(int index) {
    if (_activeBullets.containsKey(index)) {
      Bullet bullet = _activeBullets.remove(index)!; // 활성화 Map에서 제거
      bullet.inactivate(); // 총알 비활성화 처리
      _inactiveBullets.addLast(bullet); // 비활성화 큐에 추가
      _activeBulletsList.clear();
      _activeBulletsList.addAll(_activeBullets.values);
    }
  }

  @override
  void onRemove() {
    bulletFireSubscription?.cancel();
    enemyDamageSubscription?.cancel();
    bulletInactivateSubscription?.cancel();
    gameItemInactivateSubscription?.cancel();
    super.onRemove();
  }
}
