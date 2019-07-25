import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/trending_language_bean.dart';
import 'package:open_git/manager/trending_manager.dart';

class TrendingLanguageBloc extends BaseListBloc<TrendingLanguageBean> {
  static final String TAG = "TrendingLanguageBloc";

  bool _isInit = false;

  Map<String, double> _letterOffsetMap = new Map();

  @override
  PageType getPageType() {
    return PageType.trending_language;
  }

  @override
  void initData(BuildContext context) async {
    if (_isInit) {
      return;
    }
    _isInit = true;

    _showLoading();
    await _fetchLanguageList();
    _hideLoading();

    refreshStatusEvent();
  }

  double getLetterHeight() {
    return 40.0;
  }

  double getItemHeight() {
    return 50.0;
  }

  double getOffset(String letter) {
    return _letterOffsetMap[letter];
  }

  @override
  Future getData() async {
    await _fetchLanguageList();
  }

  Future _fetchLanguageList() async {
    LogUtil.v('_fetchLanguageList', tag: TAG);
    try {
      var result = await TrendingManager.instance.getLanguage();
      if (bean.data == null) {
        bean.data = List();
      }
      bean.data.clear();
      if (result != null) {
        bean.data.addAll(result);
      }
      _sortListByLetter(bean.data);
      TrendingLanguageBean item = TrendingLanguageBean('', 'All code language', letter: 'A');
      bean.data.insert(0, item);
      _setShowLetter(bean.data);
      _initListOffset(bean.data);
      sink.add(bean);
    } catch (_) {}
  }

  void _sortListByLetter(List<TrendingLanguageBean> list) {
    if (list == null || list.isEmpty) return;
    list.sort(
      (a, b) {
        if (a.letter == "@" || b.letter == "#") {
          return -1;
        } else if (a.letter == "#" || b.letter == "@") {
          return 1;
        } else {
          return a.letter.compareTo(b.letter);
        }
      },
    );
  }

  void _setShowLetter(List<TrendingLanguageBean> list) {
    if (list != null && list.isNotEmpty) {
      String tempLetter;
      for (int i = 0, length = list.length; i < length; i++) {
        TrendingLanguageBean bean = list[i];
        String letter = bean.letter;
        if (tempLetter != letter) {
          tempLetter = letter;
          bean.isShowLetter = true;
        } else {
          bean.isShowLetter = false;
        }
      }
    }
  }

  void _initListOffset(List<TrendingLanguageBean> list) {
    _letterOffsetMap.clear();
    double offset = 0;
    String letter;
    list?.forEach((v) {
      if (letter != v.letter) {
        letter = v.letter;
        _letterOffsetMap.putIfAbsent(letter, () => offset);
        offset = offset + getLetterHeight() + getItemHeight();
      } else {
        offset = offset + getItemHeight();
      }
    });
  }

  void _showLoading() {
    bean.isLoading = true;
    sink.add(bean);
  }

  void _hideLoading() {
    bean.isLoading = false;
    sink.add(bean);
  }
}
