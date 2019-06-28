import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/localizations/app_localizations_delegate.dart';
import 'package:open_git/redux/about/about_middleware.dart';
import 'package:open_git/redux/about/timeline_middleware.dart';
import 'package:open_git/redux/app_reducer.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/event/event_middleware.dart';
import 'package:open_git/redux/home/home_middleware.dart';
import 'package:open_git/redux/issue/issue_middleware.dart';
import 'package:open_git/redux/profile/follow_middleware.dart';
import 'package:open_git/redux/repos/repos_detail_middleware.dart';
import 'package:open_git/redux/repos/repos_middleware.dart';
import 'package:open_git/redux/repos/repos_source_code_middleware.dart';
import 'package:open_git/redux/repos/repos_source_file_middleware.dart';
import 'package:open_git/redux/trend/trend_middleware.dart';
import 'package:open_git/redux/user/user_middleware.dart';
import 'package:open_git/route/application.dart';
import 'package:open_git/route/routes.dart';
import 'package:redux/redux.dart';

void main() {
  final store = new Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [
      UserMiddleware(),
      HomeMiddleware(),
      ReposMiddleware(),
      EventMiddleware(),
      IssueMiddleware(),
      TrendMiddleware(),
      AboutMiddleware(),
      TimelineMiddleware(),
      FollowMiddleware(),
      ReposDetailMiddleware(),
      ReposSourceFileMiddleware(),
      ReposSourceCodeMiddleware(),
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
    final router = new Router();

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
    return new StoreProvider<AppState>(
      store: widget.store,
      child: StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          return new MaterialApp(
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
