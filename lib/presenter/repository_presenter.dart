import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/contract/repository_contract.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/manager/user_manager.dart';

class RepositoryPresenter extends IRepositoryPresenter {
  @override
  getUserRepos(int page, bool isStar, bool isFromMore) {
    UserBean userBean = LoginManager.instance.getUserBean();
    if (userBean != null) {
      return UserManager.instance.getUserRepos(userBean.login, page, null, isStar, (data) {
        if (data != null && data.length > 0) {
          List<Repository> list = new List();
          for (int i = 0; i < data.length; i++) {
            var dataItem = data[i];
            list.add(Repository.fromJson(dataItem));
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
