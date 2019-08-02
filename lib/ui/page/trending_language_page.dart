import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/trending_language_bean.dart';
import 'package:open_git/bloc/trending_language_bloc.dart';

class TrendingLanguagePage extends BaseListStatelessWidget<TrendingLanguageBean,
    TrendingLanguageBloc> {
  static final String TAG = "TrendingLanguagePage";

  @override
  PageType getPageType() => PageType.trending_language;

  @override
  String getTitle(BuildContext context) => 'Language';

  @override
  bool isShowSideBar() => true;

  @override
  double getOffset(BuildContext context, String letter) {
    TrendingLanguageBloc bloc = BlocProvider.of<TrendingLanguageBloc>(context);
    return bloc.getOffset(letter);
  }

  @override
  Widget builderItem(BuildContext context, TrendingLanguageBean item) {
    TrendingLanguageBloc bloc = BlocProvider.of<TrendingLanguageBloc>(context);

    String letter = item.letter;
    return Column(
      children: <Widget>[
        Offstage(
          offstage: !item.isShowLetter,
          child: _buildLetterWidget(context, letter),
        ),
        SizedBox(
          height: bloc.getItemHeight(),
          child: ListTile(
            title: Text(
              item.name,
              style: YZConstant.smallText,
            ),
            onTap: () {
              Navigator.pop(context, item.name);
            },
          ),
        )
      ],
    );
  }

  Widget _buildLetterWidget(BuildContext context, String letter) {
    TrendingLanguageBloc bloc = BlocProvider.of<TrendingLanguageBloc>(context);

    return Container(
      height: bloc.getLetterHeight(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$letter',
        softWrap: false,
        style: YZConstant.smallSubText,
      ),
    );
  }
}
