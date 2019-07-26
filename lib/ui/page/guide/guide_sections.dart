// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Raw data for the animation demo.

import 'package:flutter/material.dart';

const Color _mariner = Color(0xFF3B5F8F);
const Color _mediumPurple = Color(0xFF8266D4);
const Color _tomato = Color(0xFFF95B57);
const Color _mySin = Color(0xFFF3A646);

class SectionDetail {
  const SectionDetail({
    this.title,
    this.imageAsset,
    this.isShowBtn: false,
  });

  final String title;
  final String imageAsset;
  final bool isShowBtn;
}

class Section {
  const Section({
    this.title,
    this.leftColor,
    this.rightColor,
    this.details,
  });

  final String title;
  final Color leftColor;
  final Color rightColor;
  final List<SectionDetail> details;

  @override
  bool operator ==(Object other) {
    if (other is! Section) return false;
    final Section otherSection = other;
    return title == otherSection.title;
  }

  @override
  int get hashCode => title.hashCode;
}

const SectionDetail _home = SectionDetail(
  title: '项目、动态、Issue一目了然',
);

const SectionDetail _homeImage = SectionDetail(
  imageAsset: 'assets/images/bg_guide_home.png',
);

const SectionDetail _reposDetail = SectionDetail(
  title: 'Star或关注您喜欢的项目',
);

const SectionDetail __reposDetailImage = SectionDetail(
  imageAsset: 'assets/images/bg_guide_repos_detail.png',
);

const SectionDetail _issueDetail = SectionDetail(
  title: '评论、编辑、点赞随便玩',
);

const SectionDetail _issueDetailImage = SectionDetail(
  imageAsset: 'assets/images/bg_guide_issue_detail.png',
);

const SectionDetail _theme = SectionDetail(
  title: '多种主题任意切换',
);

const SectionDetail _themeImage = SectionDetail(
  imageAsset: 'assets/images/bg_guide_theme.png',
);

const SectionDetail _experienceButton = SectionDetail(
  title: '立即体验',
  isShowBtn: true,
);

const SectionDetail _empty = SectionDetail(
  title: '',
);

final List<Section> allSections = <Section>[
  const Section(
    title: '主页',
    leftColor: _mediumPurple,
    rightColor: _mariner,
    details: <SectionDetail>[
      _home,
      _homeImage,
      _empty,
    ],
  ),
  const Section(
    title: '项目详情',
    leftColor: _tomato,
    rightColor: _mediumPurple,
    details: <SectionDetail>[
      _reposDetail,
      __reposDetailImage,
      _empty,
    ],
  ),
  const Section(
    title: '问题详情',
    leftColor: _mySin,
    rightColor: _tomato,
    details: <SectionDetail>[
      _issueDetail,
      _issueDetailImage,
      _empty,
    ],
  ),
  const Section(
    title: '主题',
    leftColor: Colors.white,
    rightColor: _tomato,
    details: <SectionDetail>[
      _theme,
      _themeImage,
      _experienceButton,
    ],
  ),
];
