// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/common/shared_prf_key.dart';
import 'package:open_git/redux/actions.dart';
import 'package:open_git/redux/state.dart';
import 'package:open_git/util/shared_prf_util.dart';
import 'package:redux/redux.dart';

import '../theme.dart';

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
  new Palette(
      name: 'RED',
      primary: Colors.red,
      accent: Colors.redAccent,
      threshold: 300),
  new Palette(
      name: 'PINK',
      primary: Colors.pink,
      accent: Colors.pinkAccent,
      threshold: 200),
  new Palette(
      name: 'PURPLE',
      primary: Colors.purple,
      accent: Colors.purpleAccent,
      threshold: 200),
  new Palette(
      name: 'DEEP PURPLE',
      primary: Colors.deepPurple,
      accent: Colors.deepPurpleAccent,
      threshold: 200),
  new Palette(
      name: 'INDIGO',
      primary: Colors.indigo,
      accent: Colors.indigoAccent,
      threshold: 200),
  new Palette(
      name: 'BLUE',
      primary: Colors.blue,
      accent: Colors.blueAccent,
      threshold: 400),
  new Palette(
      name: 'LIGHT BLUE',
      primary: Colors.lightBlue,
      accent: Colors.lightBlueAccent,
      threshold: 500),
  new Palette(
      name: 'CYAN',
      primary: Colors.cyan,
      accent: Colors.cyanAccent,
      threshold: 600),
  new Palette(
      name: 'TEAL',
      primary: Colors.teal,
      accent: Colors.tealAccent,
      threshold: 400),
  new Palette(
      name: 'GREEN',
      primary: Colors.green,
      accent: Colors.greenAccent,
      threshold: 500),
  new Palette(
      name: 'LIGHT GREEN',
      primary: Colors.lightGreen,
      accent: Colors.lightGreenAccent,
      threshold: 600),
  new Palette(
      name: 'LIME',
      primary: Colors.lime,
      accent: Colors.limeAccent,
      threshold: 800),
  new Palette(
      name: 'YELLOW', primary: Colors.yellow, accent: Colors.yellowAccent),
  new Palette(name: 'AMBER', primary: Colors.amber, accent: Colors.amberAccent),
  new Palette(
      name: 'ORANGE',
      primary: Colors.orange,
      accent: Colors.orangeAccent,
      threshold: 700),
  new Palette(
      name: 'DEEP ORANGE',
      primary: Colors.deepOrange,
      accent: Colors.deepOrangeAccent,
      threshold: 400),
  new Palette(name: 'BROWN', primary: Colors.brown, threshold: 200),
  new Palette(name: 'GREY', primary: Colors.grey, threshold: 500),
  new Palette(name: 'BLUE GREY', primary: Colors.blueGrey, threshold: 500),
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
    return new Semantics(
      container: true,
      child: new Container(
        height: kColorItemHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        color: color,
        child: new SafeArea(
          top: false,
          bottom: false,
          child: FlatButton(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text('$prefix$index'),
                new Text(colorString()),
              ],
            ),
            onPressed: (){
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
      return new DefaultTextStyle(
        style: index > colors.threshold ? whiteTextStyle : blackTextStyle,
        child: new ColorItem(
            index: index,
            color: colors.primary[index],
            onChangeTheme: onChangeTheme),
      );
    }).toList();

    if (colors.accent != null) {
      colorItems.addAll(accentKeys.map((int index) {
        return new DefaultTextStyle(
          style: index > colors.threshold ? whiteTextStyle : blackTextStyle,
          child: new ColorItem(
              index: index,
              color: colors.accent[index],
              prefix: 'A',
              onChangeTheme: onChangeTheme),
        );
      }).toList());
    }

    return new ListView(
      itemExtent: kColorItemHeight,
      children: colorItems,
    );
  }
}

class ThemeSelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          return new DefaultTabController(
            length: allPalettes.length,
            child: new Scaffold(
              appBar: new AppBar(
                elevation: 0.0,
                title: const Text("主题色"),
                bottom: new TabBar(
                  isScrollable: true,
                  tabs: allPalettes
                      .map((Palette swatch) => new Tab(text: swatch.name))
                      .toList(),
                ),
              ),
              body: new TabBarView(
                children: allPalettes.map((Palette colors) {
                  return new PaletteTabView(
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
