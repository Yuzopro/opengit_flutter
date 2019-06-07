import 'package:open_git/contract/introduction_contract.dart';
import 'package:open_git/manager/repos_manager.dart';

class IntroductionPresenter extends IIntroductionPresenter {
  @override
  getReposReleases(userName, repos, int page, bool isFromMore) async {
    final response = await ReposManager.instance
        .getReposReleases(userName, repos, page: page);
    if (view != null) {
      view.setList(response, isFromMore);
    }
    return response;
  }
}
