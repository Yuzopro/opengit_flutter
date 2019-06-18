import 'package:rxdart/rxdart.dart';

abstract class BaseBloc<T> {

  BehaviorSubject<T> _subject = BehaviorSubject<T>();

  Sink<T> get sink => _subject.sink;

  Stream<T> get stream => _subject.stream;

  void initState();

  void dispose() {
   _subject.close();
  }
  
}
