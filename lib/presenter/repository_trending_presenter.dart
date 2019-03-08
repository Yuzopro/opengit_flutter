import 'package:open_git/bean/trending_bean.dart';
import 'package:open_git/contract/repository_trending_contract.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/util/trending_util.dart';

class RepositoryTrendingPresenter extends IRepositoryTrendingPresenter {
  @override
  getReposTrending(since, trendingType) {
    return ReposManager.instance.getTrending(since, trendingType, (data) {
      var repos = TrendingUtil.htmlToRepo(data);
      if (repos != null && repos.length > 0) {
        List<TrendingBean> list = new List();
        for (int i = 0; i < repos.length; i++) {
          var dataItem = repos[i];
          list.add(dataItem);
        }
        if (view != null) {
          view.setTrendingList(list);
        }
      }
    }, (code, msg) {});
  }
}
