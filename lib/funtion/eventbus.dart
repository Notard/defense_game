import 'dart:async';

class EventBus {
  // Singleton pattern implementation
  static final EventBus _instance = EventBus._internal();

  factory EventBus() {
    return _instance;
  }

  EventBus._internal();

  final _eventStream = StreamController<dynamic>.broadcast();

  StreamSubscription<T> on<T>(void Function(T event) onData) {
    Stream<T> stream =
        _eventStream.stream.where((event) => event is T).cast<T>();
    return stream.listen(onData);
  }

  void fire(dynamic event) {
    if (!_eventStream.isClosed) {
      _eventStream.add(event);
    }
  }

  void dispose() {
    _eventStream.close();
  }
}
