import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_stateless_widget.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/bloc/home_bloc.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/route/navigator_util.dart';

class HomePage extends BaseListStatelessWidget<Entrylist, HomeBloc> {
  static final String TAG = "HomePage";

  @override
  bool isShowAppBar() {
    return false;
  }

  @override
  PageType getPageType() {
    return PageType.home;
  }

  @override
  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _showAlertDialog(context);
      },
      child: Text(
        AppLocalizations.of(context).currentlocal.disclaimer_,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget builderItem(BuildContext context, Entrylist item) {
    return InkWell(
        child: Container(
          color: Color(YZColors.white),
          margin: EdgeInsets.only(bottom: 8.0),
          padding: EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  _getItemOwner(item.user.username, item.user.avatarLarge),
                  _getItemTag(item.tags),
                ],
              ),
              //全称
              SizedBox(
                height: 5.0,
              ),
              Text(
                item.title ?? "",
                style: YZConstant.middleTextBold,
              ),
              SizedBox(
                height: 5.0,
              ),
              //描述
              Text(
                item.content,
                style: YZConstant.smallSubText,
              ),
              //底部数据
              Row(
                children: <Widget>[
                  _getItemBottom(
                      'image/ic_like.png', item.collectionCount.toString()),
                  _getItemBottom(
                      'image/ic_comment.png', item.commentsCount.toString()),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          NavigatorUtil.goWebView(context, item.title, item.originalUrl);
        });
  }

  Widget _getItemOwner(String name, String head) {
    return Expanded(
      child: Row(
        children: <Widget>[
          ImageUtil.getCircleNetworkImage(
              head, 24.0, "image/ic_default_head.png"),
          SizedBox(
            width: 6.0,
          ),
          SizedBox(
            width: 200.0,
            child: Text(
              name,
              maxLines: 1,
              style: YZConstant.middleText,
            ),
          )
        ],
      ),
      flex: 1,
    );
  }

  Widget _getItemBottom(String icon, String count) {
    return Padding(
      padding: EdgeInsets.only(right: 12.0),
      child: Row(
        children: <Widget>[
          Image(width: 12.0, height: 12.0, image: AssetImage(icon)),
          SizedBox(
            width: 4.0,
          ),
          Text(
            count,
            style: YZConstant.minSubText,
          ),
        ],
      ),
    );
  }

  Widget _getItemTag(List<Tags> tags) {
    String tag = "";
    if (tags != null && tags.length > 0) {
      for (int i = 0; i < tags.length; i++) {
        tag += (tags[i].title + "\/");
      }
    }
    return Text(
      tag,
      style: YZConstant.middleSubText,
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).currentlocal.disclaimer,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(Config.disclaimerText1),
                Text(Config.disclaimerText2),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), // 圆角

          actions: <Widget>[
            Container(
              width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context).currentlocal.got_it,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
