import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/contract/repository_contract.dart';
import 'package:open_git/manager/user_manager.dart';
import 'package:open_git/util/markdown_util.dart';

class RepositoryPresenter extends IRepositoryPresenter {
  @override
  getUserRepos(userBean, int page, bool isStar, bool isFromMore) {
    if (userBean != null) {
      return UserManager.instance
          .getUserRepos(userBean.login, page, null, isStar, (data) {
        if (data != null && data.length > 0) {
          List<Repository> list = new List();
          for (int i = 0; i < data.length; i++) {
            var dataItem = data[i];
            Repository repository = Repository.fromJson(dataItem);
            repository.description = MarkdownUtil.getGitHubEmojHtml(
                repository.description ?? "暂无描述");
            list.add(repository);
          }
          if (view != null) {
            view.setList(list, isFromMore);
          }
        }
      }, (code, msg) {
        print("code is $code @msg is $msg");
      });
    }
  }
}
