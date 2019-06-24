import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/list_page_type.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/repos/repos_actions.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/ui/repos/repos_page_view_model.dart';
import 'package:open_git/ui/widget/yz_pull_refresh_list.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/log_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReposPage extends StatefulWidget {
  final ListPageType type;

  const ReposPage({Key key, this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReposPageState();
  }
}

class ReposPageState extends State<ReposPage>
    with AutomaticKeepAliveClientMixin {
  RefreshController controller;

  @override
  void initState() {
    super.initState();
    controller = new RefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ReposPageViewModel>(
      distinct: true,
      onInit: (store) => store.dispatch(FetchReposAction(widget.type)),
      converter: (store) => ReposPageViewModel.fromStore(store, widget.type),
      builder: (_, viewModel) => ReposPageContent(viewModel, controller),
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

class ReposPageContent extends StatelessWidget {
  static final String TAG = "ReposPageContent";

  ReposPageContent(this.viewModel, this.controller);

  final ReposPageViewModel viewModel;
  final RefreshController controller;

  @override
  Widget build(BuildContext context) {
    LogUtil.v('build', tag: TAG);

    return new YZPullRefreshList(
      status: viewModel.status,
      refreshStatus: viewModel.refreshStatus,
      itemCount: viewModel.repos == null ? 0 : viewModel.repos.length,
      controller: controller,
      onRefreshCallback: viewModel.onRefresh,
      onLoadCallback: viewModel.onLoad,
      itemBuilder: (context, index) {
        return _buildItem(context, viewModel.repos[index]);
      },
    );
  }

  Widget _buildItem(BuildContext context, Repository item) {
    return new InkWell(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  _getItemOwner(item.owner.avatarUrl, item.owner.login),
                  _getItemLanguage(item.language ?? ""),
                ],
              ),
              //全称
              Padding(
                padding: new EdgeInsets.only(top: 6.0, bottom: 6.0),
                child: Text(
                  item.fullName ?? "",
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              //描述
              Text(
                item.description,
                style: new TextStyle(color: Colors.black54, fontSize: 12.0),
              ),
              //底部数据
              Row(
                children: <Widget>[
                  _getItemBottom(
                      Image(
                          width: 12.0,
                          height: 12.0,
                          image: new AssetImage('image/ic_star.png')),
                      item.stargazersCount.toString()),
                  _getItemBottom(
                      Image(
                          width: 12.0,
                          height: 12.0,
                          image: new AssetImage('image/ic_issue.png')),
                      item.openIssuesCount.toString()),
                  _getItemBottom(
                      Image(
                          width: 12.0,
                          height: 12.0,
                          image: new AssetImage('image/ic_branch.png')),
                      item.forksCount.toString()),
                  Text(
                    item.fork ? "Forked" : "",
                    style: new TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          NavigatorUtil.goReposDetail(
              context, item.owner.login, item.name, true);
        });
  }

  Widget _getItemOwner(String ownerHead, String ownerName) {
    return Row(
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
    );
  }

  Widget _getItemLanguage(String language) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ClipOval(
            child: Container(
              color: Colors.black87,
              width: 8.0,
              height: 8.0,
            ),
          ),
          Padding(
            padding: new EdgeInsets.only(left: 4.0),
            child: Text(
              language,
              style: new TextStyle(color: Colors.black54, fontSize: 12.0),
            ),
          ),
        ],
      ),
      flex: 1,
    );
  }

  Widget _getItemBottom(Widget icon, String count) {
    return new Padding(
      padding: new EdgeInsets.only(right: 12.0),
      child: Row(
        children: <Widget>[
          icon,
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
}
