import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/common/shared_prf_key.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/util/locale_util.dart';
import 'package:open_git/util/shared_prf_util.dart';
import 'package:redux/redux.dart';

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).currentlocal.language),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                title: Text('跟随系统'),
                trailing: Icon(Icons.navigate_next),
                onTap: () {
                  vm.onChangeLanguage(0);
                },
              ),
              ListTile(
                title: Text('简体中文'),
                trailing: Icon(Icons.navigate_next),
                onTap: () {
                  vm.onChangeLanguage(1);
                },
              ),
              ListTile(
                title: Text('English'),
                trailing: Icon(Icons.navigate_next),
                onTap: () {
                  vm.onChangeLanguage(2);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final Function(int) onChangeLanguage;

  _ViewModel({this.onChangeLanguage});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onChangeLanguage: (language) {
        SharedPrfUtils.saveInt(SharedPrfKey.SP_KEY_LANGUAGE_COLOR, language);
        store.dispatch(
            RefreshLocalAction(LocaleUtil.changeLocale(store.state, language)));
      },
    );
  }
}
