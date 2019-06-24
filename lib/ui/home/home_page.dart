import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/bean/release_asset_bean.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/list_page_type.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/ui/home/home_page_view_model.dart';
import 'package:open_git/ui/widget/yz_pull_refresh_list.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/log_util.dart';
import 'package:open_git/util/update_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

bool isShowUpdateDialog = false;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  RefreshController controller;

  @override
  void initState() {
    super.initState();
    controller = new RefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomePageViewModel>(
      distinct: true,
      onInit: (store) => store.dispatch(FetchAction(ListPageType.home)),
      converter: (store) => HomePageViewModel.fromStore(store),
      builder: (_, viewModel) => HomesPageContent(viewModel, controller),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (controller != null) {
      controller.dispose();
      controller = null;
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class HomesPageContent extends StatelessWidget {
  static final String TAG = "HomesPageContent";

  HomesPageContent(this.viewModel, this.controller);

  final HomePageViewModel viewModel;
  final RefreshController controller;

  @override
  Widget build(BuildContext context) {
    LogUtil.v('build', tag: TAG);

    _showUpdateDialog(context, viewModel.releaseBean);

    return new YZPullRefreshList(
      status: viewModel.status,
      refreshStatus: viewModel.refreshStatus,
      itemCount: viewModel.homes == null ? 0 : viewModel.homes.length,
      controller: controller,
      onRefreshCallback: viewModel.onRefresh,
      onLoadCallback: viewModel.onLoad,
      itemBuilder: (context, index) {
        return _buildItem(context, viewModel.homes[index]);
      },
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _showAlertDialog(context);
        },
        child: new Text(
          '免责\n声明',
          style: new TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildItem(BuildContext context, Entrylist item) {
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
                Text(Config.disclaimerText1),
                Text(Config.disclaimerText2),
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

  void _showUpdateDialog(BuildContext context, ReleaseBean bean) {
    if (isShowUpdateDialog || bean == null) {
      return;
    }
    isShowUpdateDialog = true;
    Observable.just(1).delay(new Duration(milliseconds: 200)).listen((_) {
      String url = "";
      if (bean.assets != null && bean.assets.length > 0) {
        ReleaseAssetBean assetBean = bean.assets[0];
        if (assetBean != null) {
          url = assetBean.downloadUrl;
        }
      }
      UpdateUtil.showUpdateDialog(context, bean.name, bean.body, url);
    });
  }
}
