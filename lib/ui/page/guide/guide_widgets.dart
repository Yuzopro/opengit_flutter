// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

import 'guide_sections.dart';

const double kSectionIndicatorWidth = 32.0;

// The card for a single section. Displays the section's gradient and background image.
class SectionCard extends StatelessWidget {
  const SectionCard({Key key, @required this.section})
      : assert(section != null),
        super(key: key);

  final Section section;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: section.title,
      button: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              section.leftColor,
              section.rightColor,
            ],
          ),
        ),
      ),
    );
  }
}

// The title is rendered with two overlapping text widgets that are vertically
// offset a little. It's supposed to look sort-of 3D.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key key,
    @required this.section,
    @required this.scale,
    @required this.opacity,
  })  : assert(section != null),
        assert(scale != null),
        assert(opacity != null && opacity >= 0.0 && opacity <= 1.0),
        super(key: key);

  final Section section;
  final double scale;
  final double opacity;

  static const TextStyle sectionTitleStyle = TextStyle(
    fontFamily: 'Raleway',
    inherit: false,
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    textBaseline: TextBaseline.alphabetic,
  );

  static final TextStyle sectionTitleShadowStyle = sectionTitleStyle.copyWith(
    color: const Color(0x19000000),
  );

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: Transform(
          transform: Matrix4.identity()..scale(scale),
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 4.0,
                child: Text(section.title, style: sectionTitleShadowStyle),
              ),
              Text(section.title, style: sectionTitleStyle),
            ],
          ),
        ),
      ),
    );
  }
}

// Small horizontal bar that indicates the selected section.
class SectionIndicator extends StatelessWidget {
  const SectionIndicator({Key key, this.opacity = 1.0}) : super(key: key);

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: kSectionIndicatorWidth,
        height: 3.0,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}

// Display a single SectionDetail.
class SectionDetailView extends StatelessWidget {
  SectionDetailView({Key key, @required this.detail}) : super(key: key);

  final SectionDetail detail;

  @override
  Widget build(BuildContext context) {
    Widget item;
    if (detail.title == null) {
      item = Container(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Image.asset(
            detail.imageAsset,
            width: 240,
            height: 432,
          ),
        ),
      );
    } else if (detail.isShowBtn) {
      item = _buildButton(context, detail.title);
    } else if (detail.title != null) {
      item = Container(
        height: 56.0,
        alignment: Alignment.center,
        child: Text(
          detail.title,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: item,
    );
  }

  Container _buildButton(BuildContext context, String title) {
    return Container(
      height: 56.0,
      alignment: Alignment.center,
      child: InkWell(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Colors.white,
                Color(0xFFF95B57),
              ],
            ),
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Container(
            height: 36.0,
            width: 220.0,
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        onTap: () {
          _onExperience(context);
        },
      ),
    );
  }

  void _onExperience(BuildContext context) {
    Store<AppState> store = StoreProvider.of(context);
    LoginStatus status = store.state.userState.status;
    if (status == LoginStatus.success) {
      NavigatorUtil.goMain(context);
    } else if (status == LoginStatus.error) {
      NavigatorUtil.goLogin(context);
    }
  }
}
