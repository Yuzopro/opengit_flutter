import 'package:flutter/material.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseBloc<T> {
  static final String TAG = "BaseBloc";

  int page = 1;

  bool noMore = true;

  BehaviorSubject<T> _subject = BehaviorSubject<T>();

  Sink<T> get sink => _subject.sink;

  Stream<T> get stream => _subject.stream;

  BehaviorSubject<StatusEvent> _statusSubject = BehaviorSubject<StatusEvent>();

  Sink<StatusEvent> get statusSink => _statusSubject.sink;

  Stream<StatusEvent> get statusStream =>
      _statusSubject.stream.asBroadcastStream();

  void initData(BuildContext context);

  ListPageType getListPageType();

  Future getData();

  void onRefresh() async {
    LogUtil.v('onRefresh type is ${getListPageType().toString()}',tag: TAG);
    await getData();
    refreshStatusEvent();
  }

  void onLoadMore() async {
    LogUtil.v('onLoadMore type is ${getListPageType().toString()}',tag: TAG);
    await getData();
    refreshStatusEvent();
  }

  void dispose() {
    _subject.close();
    sink.close();
    _statusSubject.close();
    statusSink.close();
  }

  void refreshStatusEvent() {
    LogUtil.v('refreshStatusEvent type is ${getListPageType().toString()}',tag: TAG);
    statusSink.add(StatusEvent(page, noMore, getListPageType()));
  }
}
