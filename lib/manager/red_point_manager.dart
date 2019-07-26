import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class RedPointManager {
  factory RedPointManager() => _getInstance();

  static RedPointManager get instance => _getInstance();
  static RedPointManager _instance;

  BehaviorSubject<bool> _subject = BehaviorSubject<bool>();

  List<State> _stateList = List();

  Sink<bool> get sink => _subject.sink;

  Stream<bool> get stream => _subject.stream;

  bool _isUpgrade = false;

  RedPointManager._internal() {
    stream.listen((event) {
      _stateList.forEach((state) {
        state.setState(() {});
      });
    });
  }

  void addState(State state) {
    _stateList.add(state);
  }

  void removeState(State state) {
    _stateList.remove(state);
  }

  static RedPointManager _getInstance() {
    if (_instance == null) {
      _instance = new RedPointManager._internal();
    }
    return _instance;
  }

  bool get isUpgrade => _isUpgrade;

  set isUpgrade(bool value) {
    _isUpgrade = value;
    sink.add(value);
  }

  void dispose() {
    _subject.close();
    sink.close();
  }
}
