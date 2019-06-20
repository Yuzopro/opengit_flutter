import 'package:flutter/material.dart';
import 'package:open_git/base/base_list_stateless_widget.dart';
import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/bloc/home_bloc.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/image_util.dart';

const disclaimerText1 = '本APP属于个人的非赢利性开源项目，以供开源社区使用，凡本APP转载的所有的文章 、'
    '图片、音频、视频文件等资料的版权归版权所有人所有，本APP采用的非本站原创文章及'
    '图片等内容无法一一和版权者联系，如果本网所选内容的文章作者及编辑认为其作品不宜'
    '上网供大家浏览，或不应无偿使用请及时用电子邮件或电话通知我们，以迅速采取适当措施，'
    '避免给双方造成不必要的经济损失。';

const disclaimerText2 = '对于已经授权本APP独家使用并提供给本站资料的版权所有人的文章、'
    '图片等资料，如需转载使用，需取得本站和版权所有人的同意。本APP所刊发、转载的文章，其版权均归原'
    '作者所有，如其他媒体、网站或个人从本网下载使用，请在转载有关文章时务必尊重该文章的著作权，'
    '保留本网注明的“稿件来源”，并自负版权等法律责任。';

class BookMarkPage extends BaseListStatelessWidget<Entrylist, HomeBloc> {
  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context).currentlocal.bookmark;
  }

  @override
  Widget buildFloatingActionButton(BuildContext context) {
    return new FloatingActionButton(
      onPressed: () {
        _showAlertDialog(context);
      },
      child: new Text(
        '免责\n声明',
        style: new TextStyle(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget builderItem(BuildContext context, Entrylist item) {
    return new InkWell(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  _getItemOwner(item.user.avatarLarge, item.user.username),
                  _getItemTag(item.tags),
                ],
              ),
              //全称
              Padding(
                padding: new EdgeInsets.only(top: 6.0, bottom: 6.0),
                child: Text(
                  item.title ?? "",
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              //描述
              Text(
                item.content,
                style: new TextStyle(color: Colors.black54, fontSize: 12.0),
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

  Widget _getItemOwner(String ownerHead, String ownerName) {
    return Expanded(
      child: Row(
        children: <Widget>[
          ClipOval(
            child: ImageUtil.getImageWidget(ownerHead, 18.0),
          ),
          Padding(
            padding: new EdgeInsets.only(left: 4.0),
            child: Text(
              ownerName,
              style: new TextStyle(color: Colors.black54, fontSize: 12.0),
            ),
          ),
        ],
      ),
      flex: 1,
    );
  }

  Widget _getItemBottom(String icon, String count) {
    return new Padding(
      padding: new EdgeInsets.only(right: 12.0),
      child: Row(
        children: <Widget>[
          Image(width: 12.0, height: 12.0, image: new AssetImage(icon)),
          Padding(
            padding: EdgeInsets.only(left: 3.0),
            child: Text(
              count,
              style: new TextStyle(color: Colors.grey, fontSize: 12.0),
            ),
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
    return new Text(
      tag,
      style: new TextStyle(color: Colors.grey, fontSize: 12.0),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('免责声明',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(disclaimerText1),
                Text(disclaimerText2),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)), // 圆角

          actions: <Widget>[
            new Container(
              width: 250,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '知道了',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
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
