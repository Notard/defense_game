import 'dart:async';

import 'package:defense_game/funtion/event_define.dart';
import 'package:defense_game/funtion/eventbus.dart';
import 'package:defense_game/game/main_page.dart';
import 'package:defense_game/game/title_page.dart';
import 'package:defense_game/game/game_page.dart';
import 'package:defense_game/game/game_over_page.dart';
import 'package:flame/components.dart';

class DefenseWorld extends World {
  StreamSubscription<ChangePageEvent>? changePageSubscription;

  @override
  void onLoad() async {
    super.onLoad();
    add(TitlePage());

    changePageSubscription = EventBus().on<ChangePageEvent>(onChangePageEvent);
  }

  void onChangePageEvent(ChangePageEvent event) {
    removeAll(children);
    if (event.pageType == PageType.title) {
      add(TitlePage());
    } else if (event.pageType == PageType.main) {
      add(MainPage());
    } else if (event.pageType == PageType.game) {
      add(GamePage());
    } else if (event.pageType == PageType.gameOver) {
      add(GameOverPage());
    }
  }

  @override
  void onRemove() {
    changePageSubscription?.cancel();
    super.onRemove();
  }
}
