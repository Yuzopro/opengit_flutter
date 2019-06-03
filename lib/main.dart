import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/localizations/app_localizations_delegate.dart';
import 'package:open_git/redux/state.dart';
import 'package:open_git/redux/reducer.dart';
import 'package:open_git/route/routes.dart';
import 'package:redux/redux.dart';

void main() {
  final store = new Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
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
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              AppLocalizationsDelegate.delegate,
            ],
            locale: vm.locale,
            supportedLocales: [vm.locale],
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
  final Locale locale;

  _ViewModel({this.themeData, this.locale});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      themeData: store.state.themeData,
      locale: store.state.locale,
    );
  }
}
