import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

LinearGradient SIGNUP_CARD_BACKGROUND = LinearGradient(
  tileMode: TileMode.clamp,
  begin: FractionalOffset.centerLeft,
  end: FractionalOffset.centerRight,
  stops: [0.1, 1.0],
  colors: [Colors.white38, Colors.black38],
);

LinearGradient BUTTON_BACKGROUND = LinearGradient(
  tileMode: TileMode.clamp,
  begin: FractionalOffset.centerLeft,
  end: FractionalOffset.centerRight,
  stops: [0.1, 1.0],
  colors: [Color(0xFF303030), Color(0xFFBDBDBD)],
);
