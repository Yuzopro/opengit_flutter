import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_stateless_widget.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/bloc/loading_bean.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/branch_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bean/repos_detail_bean.dart';
import 'package:open_git/bloc/repos_detail_bloc.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/widget/markdown_widget.dart';
import 'package:open_git/util/repos_util.dart';

class RepoDetailPage
    extends BaseStatelessWidget<LoadingBean<ReposDetailBean>, ReposDetailBloc> {
  @override
  PageType getPageType() {
    return PageType.repos_detail;
  }

  @override
  String getTitle(BuildContext context) {
    ReposDetailBloc bloc = BlocProvider.of<ReposDetailBloc>(context);
    return bloc.reposName;
  }

  @override
  int getItemCount(LoadingBean<ReposDetailBean> data) {
    return 1;
  }

  @override
  bool isLoading(LoadingBean<ReposDetailBean> data) {
    return data != null ? data.isLoading : true;
  }

  @override
  bool isShowAppBarActions() {
    return true;
  }

  @override
  void openWebView(BuildContext context) {
    ReposDetailBloc bloc = BlocProvider.of<ReposDetailBloc>(context);
    NavigatorUtil.goWebView(
        context, bloc.reposName, bloc.bean.data.repos.htmlUrl);
  }

  @override
  String getShareText(BuildContext context) {
    ReposDetailBloc bloc = BlocProvider.of<ReposDetailBloc>(context);
    return bloc.bean.data.repos.htmlUrl;
  }

  @override
  Widget getChild(BuildContext context, LoadingBean<ReposDetailBean> bean) {
    if (bean == null || bean.data.repos == null) {
      return Container();
    }
    ReposDetailBloc bloc = BlocProvider.of<ReposDetailBloc>(context);
    return ListView(
      children: <Widget>[
        _getHeaderWidget(context, bean.data.repos, bean.data.starStatus,
            bean.data.watchStatus, bloc),
        _getClassifyTips(context, '互动'),
        _getInteractWidget(bean.data.repos),
        _getClassifyTips(context, '详情'),
        _getDetailWidget(context, bean.data.repos, bloc),
        _getClassifyTips(context, '分支'),
        _getBranchWidget(context, bean.data.repos, bean.data.branchs, bloc),
        _getClassifyTips(context, '文档'),
        getDocumentWidget(bean.data.readme, bloc),
      ],
    );
  }

  Widget _getHeaderWidget(BuildContext context, Repository repos,
      ReposStatus starStatus, ReposStatus watchStatus, ReposDetailBloc bloc) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.book, color: Colors.grey),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          repos.fullName,
                          style: YZConstant.middleTextBold,
                          maxLines: 2,
                        ),
                      )),
                    ],
                  )),
              Text(
                FileUtil.formatFileSize(repos.size * 1024),
                style: YZConstant.middleText,
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
          height: 0.3,
        ),
        Container(
          padding: EdgeInsets.all(12.0),
          alignment: Alignment.center,
          width: ScreenUtil.getScreenWidth(context),
          child: Text(
            ReposUtil.getGitHubEmojHtml(repos.description ?? '暂无描述'),
            style: YZConstant.middleText,
          ),
        ),
        Divider(
          color: Colors.grey,
          height: 0.3,
        ),
        _getStarAndWatch(starStatus, watchStatus, bloc),
      ],
    );
  }

  Widget _getStarAndWatch(
      ReposStatus starStatus, ReposStatus watchStatus, ReposDetailBloc bloc) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: <Widget>[
          _getStarAndWatchItem(
            starStatus == ReposStatus.active ? Icons.star_border : Icons.star,
            starStatus == ReposStatus.active ? 'Unstar' : 'Star',
            starStatus,
            () {
              bloc.changeStarStatus();
            },
          ),
          Container(width: 0.3, height: 20.0, color: Colors.grey),
          _getStarAndWatchItem(
            watchStatus == ReposStatus.active
                ? Icons.visibility_off
                : Icons.visibility,
            watchStatus == ReposStatus.active ? 'Unwatch' : 'watch',
            watchStatus,
            () {
              bloc.changeWatchStatus();
            },
          ),
        ],
      ),
    );
  }

  Widget _getStarAndWatchItem(
      IconData iconData, String text, ReposStatus status, onPressed) {
    return Expanded(
      child: FlatButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              status == ReposStatus.loading
                  ? SizedBox(
                      width: 15.0,
                      height: 15.0,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation(
                              Color(YZColors.subTextColor))),
                    )
                  : Icon(iconData, color: Color(YZColors.mainTextColor)),
              Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: new Text(
                  text,
                  style: TextStyle(
                      color: status == ReposStatus.loading
                          ? Color(YZColors.subTextColor)
                          : Color(YZColors.mainTextColor)),
                ),
              ),
            ],
          )),
      flex: 1,
    );
  }

  Widget _getClassifyTips(BuildContext context, String tips) {
    return Container(
      width: ScreenUtil.getScreenWidth(context),
      padding: EdgeInsets.all(12.0),
      color: Color(YZColors.subLightTextColor),
      child: Text(
        tips,
        style: YZConstant.middleText,
      ),
    );
  }

  Widget _getInteractWidget(Repository repos) {
    return new Container(
      padding: EdgeInsets.all(12.0),
      child: Row(
        children: <Widget>[
          _getInteractItem(repos.stargazersCount, 'stars'),
          _getInteractItem(repos.openIssuesCount, 'issues'),
          _getInteractItem(repos.forksCount, 'forks'),
          _getInteractItem(repos.subscribersCount, 'watchers'),
        ],
      ),
    );
  }

  Widget _getInteractItem(int count, String text) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            count.toString() ?? '0',
            style: YZConstant.smallText,
          ),
          Text(
            text,
            style: YZConstant.smallSubText,
          ),
        ],
      ),
    );
  }

  Widget _getDetailWidget(
    BuildContext context,
    Repository repos,
    ReposDetailBloc bloc,
  ) {
    return new Column(
      children: <Widget>[
        _getDetailItem(Icons.language, '语言', repos.language, true, () {
          NavigatorUtil.goReposLanguage(context, repos.language);
        }),
        Divider(
          color: Colors.grey,
          height: 0.3,
        ),
        _getDetailItem(Icons.alarm, '动态', '', true, () {
          NavigatorUtil.goReposDynamic(
              context, bloc.reposOwner, bloc.reposName);
        }),
        Divider(
          color: Colors.grey,
          height: 0.3,
        ),
        _getDetailItem(Icons.person, 'Contributors', '', true, () {
          NavigatorUtil.goRepoContributor(context, repos.contributors_url);
        }),
        Divider(
          color: Colors.grey,
          height: 0.3,
        ),
        _getDetailItem(Icons.visibility, 'Stargazers', '', true, () {
          NavigatorUtil.goRepoStargazer(context, repos.stargazers_url);
        }),
        Divider(
          color: Colors.grey,
          height: 0.3,
        ),
        _getDetailItem(Icons.perm_identity, '许可',
            repos.license != null ? repos.license.name : '', false, null),
      ],
    );
  }

  Widget _getDetailItem(IconData iconData, String text, String trailText,
      bool isShowTralIcon, onPressed) {
    return new FlatButton(
        onPressed: onPressed,
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Icon(
                    iconData,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: new Text(text),
                  )
                ],
              ),
              flex: 1,
            ),
            Row(
              children: <Widget>[
                Text(
                  trailText ?? '',
                  style: YZConstant.smallText,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: isShowTralIcon
                      ? Icon(Icons.navigate_next,
                          color: Color(YZColors.mainTextColor))
                      : Text(''),
                )
              ],
            )
          ],
        ));
  }

  Widget _getBranchWidget(BuildContext context, Repository repos,
      List<BranchBean> branchs, ReposDetailBloc bloc) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: Row(
            children: <Widget>[
              Image(
                  width: 16.0,
                  height: 16.0,
                  image: AssetImage(ImagePath.image_fork)),
              Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: new Text(
                  repos.defaultBranch,
                  style: YZConstant.middleText,
                ),
              )
            ],
          ),
          children: _isEmptyBranches(branchs)
              ? <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 15.0,
                      height: 15.0,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation(Colors.black)),
                    ),
                    height: 56.0,
                  )
                ]
              : branchs.map<Widget>((branch) {
                  return ListTile(
                      title: Text(
                    branch.name,
                    style: YZConstant.middleText,
                  ));
                }).toList(),
          onExpansionChanged: (isOpen) {
            if (isOpen) {
              bloc.fetchBranchs();
            }
          },
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 56.0,
          padding: EdgeInsets.all(12.0),
          child: Text('最后一次提交于' + DateUtil.getMultiDateStr(repos.pushedAt)),
        ),
        Divider(
          color: Colors.grey,
          height: 0.3,
        ),
        Container(
          alignment: Alignment.center,
          height: 56.0,
          child: FlatButton(
              onPressed: () {
                NavigatorUtil.goReposSourceFile(
                    context, bloc.reposOwner, bloc.reposName);
              },
              child: Text('查看源码')),
        ),
      ],
    );
  }

  Widget getDocumentWidget(String readme, ReposDetailBloc bloc) {
    return new ExpansionTile(
      title: Row(
        children: <Widget>[
          Icon(
            Icons.chrome_reader_mode,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: new Text(
              'README.md',
              style: YZConstant.middleText,
            ),
          )
        ],
      ),
      children: readme.isEmpty
          ? <Widget>[
              Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 15.0,
                  height: 15.0,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation(Colors.black)),
                ),
                height: 56.0,
              )
            ]
          : <Widget>[
              Padding(
                padding: EdgeInsets.all(12.0),
                child: MarkdownWidget(
                  markdownData: readme,
                ),
              ),
            ],
      onExpansionChanged: (isOpen) {
        if (isOpen) {
          bloc.fetchReadme();
        }
      },
    );
  }

  bool _isEmptyBranches(List<BranchBean> branchs) {
    return branchs == null || branchs.length == 0;
  }
}
