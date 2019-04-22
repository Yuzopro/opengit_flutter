import 'package:open_git/contract/repository_contract.dart';
import 'package:open_git/manager/user_manager.dart';

class RepositoryPresenter extends IRepositoryPresenter {
  @override
  getUserRepos(userBean, int page, bool isStar, bool isFromMore) async {
    if (userBean != null) {
      final result = await UserManager.instance
          .getUserRepos(userBean.login, page, null, isStar);
      if (view != null) {
        view.setList(result, isFromMore);
      }
      return result;
    }
  }
}
