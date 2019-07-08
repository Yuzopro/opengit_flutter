class StatusEvent {
  final int page;
  final bool noMore;
  final ListPageType type;

  StatusEvent(this.page, this.noMore, this.type);
}

enum ListPageType {
  home,//主页
  repos,//项目
  event,//动态
  issue,//问题
  repos_detail,//项目详情
  repos_user,//用户资料项目列表
  repos_user_star,//用户资料star项目列表
  day_trend,//日趋势
  week_trend,//周趋势
  month_trend,//月趋势
  about,//关于
  timeline,//版本更新
  following,//我关注的
  followers,//关注我的
  repos_event,//项目动态
  repos_trend,//项目语言趋势
  search_repos,//搜索项目
  search_user,//搜索用户
  search_issue,//搜索问题
  repos_source_code,//源代码
  repos_source_file,//源文件
  issue_detail,//问题详情
  reaction,//表情列表
}

enum LoadingStatus {
  idle,
  loading,
  error,
  success,
}

enum LoginStatus {
  idle,
  error,
  success,
}

enum RefreshStatus {
  idle,
  refresh,
  loading,
  refresh_no_data,
  loading_no_data,
}

enum ReposStatus {
  idle,
  active,
  inactive,
  loading,
}


