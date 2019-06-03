import 'package:flutter/material.dart';
import 'package:open_git/redux/actions.dart';
import 'package:redux/redux.dart';

final localeReducer = combineReducers<Locale>([
  TypedReducer<Locale, RefreshLocalAction>(_refresh),
]);

Locale _refresh(Locale locale, action) {
  locale = action.locale;
  return locale;
}