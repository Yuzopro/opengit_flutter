import 'package:redux/redux.dart';
import 'package:flutter/material.dart';

import 'actions.dart';

final themeReducer = combineReducers<ThemeData>([
  TypedReducer<ThemeData, RefreshThemeDataAction>(_refresh),
]);

ThemeData _refresh(ThemeData themeData, action) {
  themeData = action.themeData;
  return themeData;
}