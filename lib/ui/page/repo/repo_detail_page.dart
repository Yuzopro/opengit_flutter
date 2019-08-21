import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_stateless_widget.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/bloc/loading_bean.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_git/bean/branch_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bean/repos_detail_bean.dart';
import 'package:open_git/bloc/repo_detail_bloc.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/widget/markdown_widget.dart';
import 'package:open_git/util/repos_util.dart';

class RepoDetailPage
    extends BaseStatelessWidget<LoadingBean<ReposDetailBean>, RepoDetailBloc> {
  @override
  PageType getPageType() {
    return PageType.repos_detail;
  }

  @override
  String getTitle(BuildContext context) {
    RepoDetailBloc bloc = BlocProvider.of<RepoDetailBloc>(context);
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
    RepoDetailBloc bloc = BlocProvider.of<RepoDetailBloc>(context);
    NavigatorUtil.goWebView(
        context, bloc.reposName, bloc.bean.data.repos.htmlUrl);
  }

  @override
  String getShareText(BuildContext context) {
    RepoDetailBloc bloc = BlocProvider.of<RepoDetailBloc>(context);
    return bloc.bean.data.repos.htmlUrl;
  }

  @override
  Widget getChild(BuildContext context, LoadingBean<ReposDetailBean> bean) {
    if (bean == null || bean.data.repos == null) {
      return Container();
    }
    return ListView(
      children: <Widget>[
        _buildHeader(bean.data.repos),
        _buildAction(context, bean.data.repos, bean.data.starStatus,
            bean.data.watchStatus),
        _buildOther(context, bean.data.repos),
        _buildBranch(context, bean.data.repos, bean.data.branchs),
        _buildReadme(context, bean.data.readme),
      ],
    );
  }

  Widget _buildHeader(Repository repo) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: _buildHeaderCard(repo),
    );
  }

  Widget _buildHeaderCard(Repository repo) {
    return Card(
      elevation: 2,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildNameRow(repo),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDesc(repo),
          ),
        ],
      ),
    );
  }

  Widget _buildNameRow(Repository repo) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Icon(Icons.book, color: Color(YZColors.textColor)),
              SizedBox(
                width: 5.0,
              ),
              _buildName(repo),
            ],
          ),
        ),
        Text(
          FileUtil.formatFileSize(repo.size * 1024),
          style: YZStyle.middleText,
        )
      ],
    );
  }

  Widget _buildName(Repository repo) {
    if (repo.fork) {
      return Column(
        children: <Widget>[
          Text(
            repo.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: YZStyle.middleTextBold,
          ),
          Text(
            repo.parent.fullName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: YZStyle.smallSubText,
          ),
        ],
      );
    } else {
      return Text(
        repo.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: YZStyle.middleTextBold,
      );
    }
  }

  Widget _buildDesc(Repository repo) {
    return Text(
      ReposUtil.getGitHubEmojHtml(repo.description ?? '暂无描述'),
      style: YZStyle.middleText,
    );
  }

  Widget _buildAction(BuildContext context, Repository repo,
      ReposStatus starStatus, ReposStatus watchStatus) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: _buildActionCard(context, repo, starStatus, watchStatus),
    );
  }

  Widget _buildActionCard(BuildContext context, Repository repo,
      ReposStatus starStatus, ReposStatus watchStatus) {
    return Card(
      elevation: 2,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: _buildStarAndWatch(context, starStatus, watchStatus),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: _buildInteract(context, repo),
          )
        ],
      ),
    );
  }

  Widget _buildStarAndWatch(
      BuildContext context, ReposStatus starStatus, ReposStatus watchStatus) {
    RepoDetailBloc bloc = BlocProvider.of<RepoDetailBloc>(context);

    return Row(
      children: <Widget>[
        _buildStarAndWatchItem(
          starStatus == ReposStatus.active ? Icons.star_border : Icons.star,
          starStatus == ReposStatus.active ? 'Unstar' : 'Star',
          starStatus,
          () {
            bloc.changeStarStatus();
          },
        ),
        Container(width: 0.3, height: 20.0, color: Colors.grey),
        _buildStarAndWatchItem(
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
    );
  }

  Widget _buildInteract(BuildContext context, Repository repo) {
    return Row(
      children: <Widget>[
        _buildInteractItem(repo.stargazersCount, 'Stars', () {
          NavigatorUtil.goRepoStargazer(context, repo.stargazers_url);
        }),
        _buildInteractItem(repo.openIssuesCount, 'Issues', () {
          NavigatorUtil.goRepoIssue(context, repo.owner.login, repo.name);
        }),
        _buildInteractItem(repo.forksCount, 'Forks', () {
          NavigatorUtil.goRepoFork(context, repo.owner.login, repo.name);
        }),
        _buildInteractItem(repo.subscribersCount, 'Watchers', () {
          NavigatorUtil.goRepoSubscriber(context, repo.subscribers_url);
        }),
      ],
    );
  }

  Widget _buildOther(BuildContext context, Repository repo) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: _buildOtherCard(context, repo),
    );
  }

  Widget _buildOtherCard(BuildContext context, Repository repo) {
    RepoDetailBloc bloc = BlocProvider.of<RepoDetailBloc>(context);

    return Card(
      elevation: 2,
      child: Column(
        children: <Widget>[
          _buildOtherItem(Icons.language, '语言', repo.language, true, () {
            NavigatorUtil.goReposLanguage(context, repo.language);
          }),
          _buildOtherItem(Icons.alarm, '动态', '', true, () {
            NavigatorUtil.goReposDynamic(
                context, bloc.reposOwner, bloc.reposName);
          }),
          _buildOtherItem(Icons.person, '贡献者', '', true, () {
            NavigatorUtil.goRepoContributor(context, repo.contributors_url);
          }),
          _buildOtherItem(Icons.perm_identity, '许可',
              repo.license != null ? repo.license.name : '', false, null),
        ],
      ),
    );
  }

  Widget _buildBranch(
      BuildContext context, Repository repo, List<BranchBean> branches) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: _buildBranchCard(context, repo, branches),
    );
  }

  Widget _buildBranchCard(
      BuildContext context, Repository repo, List<BranchBean> branches) {
    RepoDetailBloc bloc = BlocProvider.of<RepoDetailBloc>(context);

    return Card(
      elevation: 2,
      child: Column(
        children: <Widget>[
          ExpansionTile(
            title: Text(
              '默认分支 ${repo.defaultBranch}',
              style: YZStyle.middleText,
            ),
            children:
                _buildBranchChildren(context, branches, repo.defaultBranch),
            onExpansionChanged: (isOpen) {
              if (isOpen) {
                bloc.fetchBranches();
              }
            },
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 56.0,
            padding: EdgeInsets.all(12.0),
            child: Text('最后一次提交于' + DateUtil.getMultiDateStr(repo.pushedAt)),
          ),
          InkWell(
            child: Container(
              alignment: Alignment.center,
              height: 56.0,
              child: Text('查看源码'),
            ),
            onTap: () {
              NavigatorUtil.goReposSourceFile(
                  context, bloc.reposOwner, bloc.reposName, repo.defaultBranch);
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBranchChildren(
      BuildContext context, List<BranchBean> branches, String defaultBranch) {
    if (_isEmptyBranches(branches)) {
      return [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: SpinKitCircle(
            color: Color(YZColors.textColor),
            size: 25.0,
          ),
        ),
      ];
    } else {
      return branches.map<Widget>((branch) {
        return ListTile(
          title: Text(
            branch.name,
            style: TextUtil.equals(branch.name, defaultBranch)
                ? YZStyle.middleSubText
                : YZStyle.middleText,
          ),
          onTap: TextUtil.equals(branch.name, defaultBranch)
              ? null
              : () {
                  RepoDetailBloc bloc =
                      BlocProvider.of<RepoDetailBloc>(context);
                  NavigatorUtil.goReposSourceFile(
                      context, bloc.reposOwner, bloc.reposName, branch.name);
                },
        );
      }).toList();
    }
  }

  Widget _buildReadme(BuildContext context, String readme) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: _buildReadmeCard(context, readme),
    );
  }

  Widget _buildReadmeCard(BuildContext context, String readme) {
    RepoDetailBloc bloc = BlocProvider.of<RepoDetailBloc>(context);

    return Card(
      elevation: 2,
      child: ExpansionTile(
        title: Row(
          children: <Widget>[
            Icon(
              Icons.chrome_reader_mode,
              color: Color(YZColors.textColor),
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              'README.md',
              style: YZStyle.middleText,
            ),
          ],
        ),
        children: _buildReadmeChildren(readme),
        onExpansionChanged: (isOpen) {
          if (isOpen) {
            bloc.fetchReadme();
          }
        },
      ),
    );
  }

  List<Widget> _buildReadmeChildren(String readme) {
    if (TextUtil.isEmpty(readme)) {
      return [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: SpinKitCircle(
            color: Color(YZColors.textColor),
            size: 25.0,
          ),
        ),
      ];
    } else {
      return [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: MarkdownWidget(
            markdownData: readme,
          ),
        )
      ];
    }
  }

  Widget _buildStarAndWatchItem(
      IconData iconData, String text, ReposStatus status, onTap) {
    return Expanded(
      child: InkWell(
        child: Container(
          height: 56.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildStarAndWatchIcon(iconData, status),
              SizedBox(
                width: 8.0,
              ),
              Text(
                text,
                style: TextStyle(
                  color: Color(_getStarAndWatchColor(status)),
                ),
              ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStarAndWatchIcon(IconData iconData, ReposStatus status) {
    if (status == ReposStatus.loading) {
      return SpinKitCircle(
        color: Color(YZColors.subTextColor),
        size: 25.0,
      );
    } else {
      return Icon(
        iconData,
        color: Color(YZColors.textColor),
      );
    }
  }

  int _getStarAndWatchColor(ReposStatus status) {
    if (status == ReposStatus.loading) {
      return YZColors.subTextColor;
    } else {
      return YZColors.textColor;
    }
  }

  Widget _buildInteractItem(int count, String text, onTap) {
    return Expanded(
      child: InkWell(
        child: Column(
          children: <Widget>[
            Text(
              count.toString() ?? '0',
              style: YZStyle.middleTextBold,
            ),
            Text(
              text,
              style: YZStyle.middleText,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildOtherItem(IconData iconData, String text, String trailText,
      bool isShowTrail, onTap) {
    return InkWell(
      child: Container(
        height: 56.0,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Icon(
                    iconData,
                    color: Color(YZColors.textColor),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    text,
                    style: YZStyle.middleText,
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  trailText ?? '',
                  style: YZStyle.smallText,
                ),
                SizedBox(
                  width: 8.0,
                ),
                _buildTrail(isShowTrail),
              ],
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildTrail(bool isShowTrail) {
    return isShowTrail
        ? Icon(Icons.navigate_next, color: Color(YZColors.textColor))
        : Text('');
  }

  bool _isEmptyBranches(List<BranchBean> branchs) {
    return branchs == null || branchs.length == 0;
  }
}
