import 'package:flutter/material.dart';
import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/contract/home_contract.dart';
import 'package:open_git/presenter/home_presenter.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/widget/pull_refresh_list.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState
    extends PullRefreshListState<HomePage, Entrylist, HomePresenter, IHomeView>
    with AutomaticKeepAliveClientMixin
    implements IHomeView {
  @override
  bool get wantKeepAlive => true;

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      body: buildBody(context),
    );
  }

  @override
  Widget getItemRow(Entrylist item) {
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
                      'image/ic_like.png',
                      item.collectionCount.toString()),
                  _getItemBottom(
                      'image/ic_comment.png',
                      item.commentsCount.toString()),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          NavigatorUtil.goWebView(context, item.title, item.originalUrl);
        });
  }

  @override
  HomePresenter initPresenter() {
    return new HomePresenter();
  }

  @override
  Future<Null> onRefresh() async {
    if (presenter != null) {
      page = 1;
      await presenter.getJueJinList(page, false);
    }
  }

  @override
  getMoreData() {
    if (presenter != null) {
      page++;
      presenter.getJueJinList(page, true);
    }
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
          Image(
              width: 12.0,
              height: 12.0,
              image: new AssetImage(icon)),
          Padding(padding: EdgeInsets.only(left: 3.0), child: Text(
            count,
            style: new TextStyle(color: Colors.grey, fontSize: 12.0),
          ),),
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
}
