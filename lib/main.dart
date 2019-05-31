import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/redux/state.dart';
import 'package:open_git/redux/reducer.dart';
import 'package:open_git/route/routes.dart';
import 'package:redux/redux.dart';

void main() {
  final store = new Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
//    middleware:
  );

  runZoned(() {
    runApp(OpenGitApp(store));
  }, onError: (Object obj, StackTrace trace) {
    print(obj);
    print(trace);
  });
}

class OpenGitApp extends StatelessWidget {
  final Store<AppState> store;

  OpenGitApp(this.store);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store: store,
      child: StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          return new MaterialApp(
            theme: vm.themeData,
            routes: AppRoutes.getRoutes(),
          );
        },
      ),
    );
  }
}

class _ViewModel {
  final ThemeData themeData;

  _ViewModel({this.themeData});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      themeData: store.state.themeData,
    );
  }
}

/**
 *    return StoreConnector<AppState, _ViewModel>(
    converter: _ViewModel.fromStore,
    builder: (context, vm) {
    });
 */
