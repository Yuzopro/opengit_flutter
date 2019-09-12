import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_stateless_widget.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/bloc/home_bloc.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/route/navigator_util.dart';

class HomePage extends BaseListStatelessWidget<Entrylist, HomeBloc> {
  static final String TAG = "HomePage";

  @override
  bool isShowAppBar() {
    return false;
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _postCard(context, item),
      ),
      onTap: () {
        NavigatorUtil.goWebView(context, item.title, item.originalUrl);
      },
    );
  }

  Widget _getItemTag(List<Tags> tags) {
    String tag = "";
    if (tags != null && tags.length > 0) {
      if (tags.length > 2) {
        tags.length = 2;
      }
      for (int i = 0; i < tags.length; i++) {
        tag += (tags[i].title + "\/");
      }
    }
    return Text(
      tag,
      style: YZStyle.smallSubText,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
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

  Widget _postCard(BuildContext context, Entrylist item) {
    return Card(
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _profileColumn(context, item),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              item.title ?? '--',
              style: YZStyle.middleTextBold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              TextUtil.isEmpty(item.content) ? '暂无描述' : item.content,
              style: YZStyle.smallTextT65,
            ),
          ),
          _actionColumn(item),
        ],
      ),
    );
  }

  Widget _profileColumn(BuildContext context, Entrylist item) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ImageUtil.getCircleNetworkImage(
              item.user.avatarLarge, 36.0, ImagePath.image_default_head),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                item.user.username ?? '--',
                style: YZStyle.smallText,
              ),
            ),
          ),
          _getItemTag(item.tags),
        ],
      );

  Widget _actionColumn(Entrylist item) => ButtonBar(
        alignment: MainAxisAlignment.start,
        children: <Widget>[
          LabelIcon(
            label: item.collectionCount.toString(),
            image: ImagePath.image_like,
          ),
          LabelIcon(
            label: item.commentsCount.toString(),
            image: ImagePath.image_comment,
          ),
        ],
      );
}
