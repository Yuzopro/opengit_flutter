import 'package:flutter/widgets.dart';

class StartCountdownAction {
  final BuildContext context;

  StartCountdownAction(this.context);
}

class StopCountdownAction {}

class CountdownAction {
  final int countdown;

  CountdownAction(this.countdown);
}
