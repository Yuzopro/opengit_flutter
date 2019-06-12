import 'package:open_git/contract/repository_trending_contract.dart';
import 'package:open_git/manager/repos_manager.dart';

class RepositoryTrendingPresenter extends IRepositoryTrendingPresenter {
  @override
  getReposTrending(since, trendingType) async {
    final response = await ReposManager.instance.getTrending(since, trendingType);
    if (response != null && view != null) {
      view.setTrendingList(response);
    }
    return response;
  }
}
