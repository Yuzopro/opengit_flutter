// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/common/shared_prf_key.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/util/shared_prf_util.dart';
import 'package:open_git/util/theme_util.dart';
import 'package:redux/redux.dart';

const double kColorItemHeight = 48.0;

class Palette {
  Palette({this.name, this.primary, this.accent, this.threshold = 900});

  final String name;
  final MaterialColor primary;
  final MaterialAccentColor accent;
  final int
      threshold; // titles for indices > threshold are white, otherwise black

  bool get isValid => name != null && primary != null && threshold != null;
}

final List<Palette> allPalettes = <Palette>[
  Palette(
      name: 'RED',
      primary: Colors.red,
      accent: Colors.redAccent,
      threshold: 300),
  Palette(
      name: 'PINK',
      primary: Colors.pink,
      accent: Colors.pinkAccent,
      threshold: 200),
  Palette(
      name: 'PURPLE',
      primary: Colors.purple,
      accent: Colors.purpleAccent,
      threshold: 200),
  Palette(
      name: 'DEEP PURPLE',
      primary: Colors.deepPurple,
      accent: Colors.deepPurpleAccent,
      threshold: 200),
  Palette(
      name: 'INDIGO',
      primary: Colors.indigo,
      accent: Colors.indigoAccent,
      threshold: 200),
  Palette(
      name: 'BLUE',
      primary: Colors.blue,
      accent: Colors.blueAccent,
      threshold: 400),
  Palette(
      name: 'LIGHT BLUE',
      primary: Colors.lightBlue,
      accent: Colors.lightBlueAccent,
      threshold: 500),
  Palette(
      name: 'CYAN',
      primary: Colors.cyan,
      accent: Colors.cyanAccent,
      threshold: 600),
  Palette(
      name: 'TEAL',
      primary: Colors.teal,
      accent: Colors.tealAccent,
      threshold: 400),
  Palette(
      name: 'GREEN',
      primary: Colors.green,
      accent: Colors.greenAccent,
      threshold: 500),
  Palette(
      name: 'LIGHT GREEN',
      primary: Colors.lightGreen,
      accent: Colors.lightGreenAccent,
      threshold: 600),
  Palette(
      name: 'LIME',
      primary: Colors.lime,
      accent: Colors.limeAccent,
      threshold: 800),
  Palette(
      name: 'YELLOW', primary: Colors.yellow, accent: Colors.yellowAccent),
  Palette(name: 'AMBER', primary: Colors.amber, accent: Colors.amberAccent),
  Palette(
      name: 'ORANGE',
      primary: Colors.orange,
      accent: Colors.orangeAccent,
      threshold: 700),
  Palette(
      name: 'DEEP ORANGE',
      primary: Colors.deepOrange,
      accent: Colors.deepOrangeAccent,
      threshold: 400),
  Palette(name: 'BROWN', primary: Colors.brown, threshold: 200),
  Palette(name: 'GREY', primary: Colors.grey, threshold: 500),
  Palette(name: 'BLUE GREY', primary: Colors.blueGrey, threshold: 500),
];

class ColorItem extends StatelessWidget {
  const ColorItem(
      {Key key,
      @required this.index,
      @required this.color,
      this.prefix = '',
      this.onChangeTheme})
      : assert(index != null),
        assert(color != null),
        assert(prefix != null),
        super(key: key);

  final int index;
  final Color color;
  final String prefix;
  final Function(Color) onChangeTheme;

  String colorString() =>
      "#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Container(
        height: kColorItemHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        color: color,
        child: SafeArea(
          top: false,
          bottom: false,
          child: FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('$prefix$index'),
                Text(colorString()),
              ],
            ),
            onPressed: () {
              onChangeTheme(color);
            },
          ),
        ),
      ),
    );
  }
}

class PaletteTabView extends StatelessWidget {
  static const List<int> primaryKeys = const <int>[
    50,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900
  ];
  static const List<int> accentKeys = const <int>[100, 200, 400, 700];

  PaletteTabView({Key key, @required this.colors, this.onChangeTheme})
      : assert(colors != null && colors.isValid),
        super(key: key);

  final Palette colors;
  final Function(Color) onChangeTheme;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle whiteTextStyle =
        textTheme.body1.copyWith(color: Colors.white);
    final TextStyle blackTextStyle =
        textTheme.body1.copyWith(color: Colors.black);
    final List<Widget> colorItems = primaryKeys.map((int index) {
      return DefaultTextStyle(
        style: index > colors.threshold ? whiteTextStyle : blackTextStyle,
        child: ColorItem(
            index: index,
            color: colors.primary[index],
            onChangeTheme: onChangeTheme),
      );
    }).toList();

    if (colors.accent != null) {
      colorItems.addAll(accentKeys.map((int index) {
        return DefaultTextStyle(
          style: index > colors.threshold ? whiteTextStyle : blackTextStyle,
          child: ColorItem(
              index: index,
              color: colors.accent[index],
              prefix: 'A',
              onChangeTheme: onChangeTheme),
        );
      }).toList());
    }

    return ListView(
      itemExtent: kColorItemHeight,
      children: colorItems,
    );
  }
}

class ThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          return DefaultTabController(
            length: allPalettes.length,
            child: Scaffold(
              appBar: AppBar(
                title:
                    Text(AppLocalizations.of(context).currentlocal.theme),
                bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  tabs: allPalettes
                      .map((Palette swatch) => Tab(text: swatch.name))
                      .toList(),
                ),
              ),
              body: TabBarView(
                children: allPalettes.map((Palette colors) {
                  return PaletteTabView(
                    colors: colors,
                    onChangeTheme: vm.onChangeTheme,
                  );
                }).toList(),
              ),
            ),
          );
        });
  }
}

class _ViewModel {
  final Function(Color) onChangeTheme;

  _ViewModel({this.onChangeTheme});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onChangeTheme: (color) {
        SharedPrfUtils.saveInt(SharedPrfKey.SP_KEY_THEME_COLOR, color.value);
        store.dispatch(RefreshThemeDataAction(AppTheme.changeTheme(color)));
      },
    );
  }
}
