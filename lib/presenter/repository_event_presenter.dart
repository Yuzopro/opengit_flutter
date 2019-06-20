import 'package:open_git/contract/repository_event_contract.dart';
import 'package:open_git/manager/repos_manager.dart';

class RepositoryEventPresenter extends IRepositoryEventPresenter {
  @override
  getReposEvent(reposOwner, reposName, int page, bool isFromMore) async {
    final response = await ReposManager.instance.getReposEvents(reposOwner, reposName, page);
    if (view != null) {
      view.setList(response, isFromMore);
    }
    return response;
  }
}
