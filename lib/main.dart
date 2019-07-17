import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/localizations/app_localizations_delegate.dart';
import 'package:open_git/redux/about/about_middleware.dart';
import 'package:open_git/redux/app_reducer.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/login/login_middleware.dart';
import 'package:open_git/redux/user/user_middleware.dart';
import 'package:open_git/route/application.dart';
import 'package:open_git/route/routes.dart';
import 'package:redux/redux.dart';

void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [
      LoginMiddleware(),
      UserMiddleware(),
      AboutMiddleware(),
    ],
  );

  runZoned(() {
    runApp(OpenGitApp(store));
  }, onError: (Object obj, StackTrace trace) {
    print(obj);
    print(trace);
  });
}

class OpenGitApp extends StatefulWidget {
  final Store<AppState> store;

  OpenGitApp(this.store) {
    final router = Router();

    AppRoutes.configureRoutes(router);

    Application.router = router;
  }

  @override
  State<StatefulWidget> createState() {
    return _OpenGitAppState();
  }
}

class _OpenGitAppState extends State<OpenGitApp> {
  static final String TAG = "OpenGitApp";

  @override
  void initState() {
    super.initState();

//    widget.store.state.platformLocale = Localizations.localeOf(context);
    widget.store.dispatch(InitAction());
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          return MaterialApp(
//            showPerformanceOverlay: true,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              AppLocalizationsDelegate.delegate,
            ],
            locale: vm.locale,
            supportedLocales: [vm.locale],
            theme: vm.themeData,
            onGenerateRoute: Application.router.generator,
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
