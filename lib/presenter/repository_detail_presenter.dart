import 'package:open_git/bean/branch_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/contract/repository_detail_contract.dart';
import 'package:open_git/manager/repos_manager.dart';

class RepositoryDetailPresenter extends IRepositoryDetailPresenter {
  static const int DEFAULT_STATE = 0;
  static const int ENABLE_STATE = 1;
  static const int DISABLE_STATE = 2;

  @override
  getReposDetail(reposOwner, reposName, bool isRefresh) {
    return ReposManager.instance.getReposDetail(reposOwner, reposName, (data) {
      if (data != null && view != null) {
        view.getReposDetailSuccess(Repository.fromJson(data), isRefresh);
      }
    }, (code, msg) {
      print("code is $code @msg is $msg");
    });
  }

  @override
  void getReadme(reposFullName, branch) {
    ReposManager.instance.getReadme(reposFullName, branch, (data) {
      if (data != null && view != null) {
        view.setReadmeContent(data);
      }
    }, (code, msg) {
      print("code is $code @msg is $msg");
    });
  }

  @override
  void getReposStar(reposOwner, reposName) {
    ReposManager.instance.getReposStar(reposOwner, reposName, (data) {
      if (view != null) {
        view.setStarState(ENABLE_STATE, false);
      }
    }, (code, msg) {
      if (view != null) {
        view.setStarState(DISABLE_STATE, false);
      }
    });
  }

  @override
  void getReposWatcher(reposOwner, reposName) {
    ReposManager.instance.getReposWatcher(reposOwner, reposName, (data) {
      if (view != null) {
        view.setWatchState(ENABLE_STATE, false);
      }
    }, (code, msg) {
      if (view != null) {
        view.setWatchState(DISABLE_STATE, false);
      }
    });
  }

  @override
  void doReposStarAction(reposOwner, reposName, int state) {
    ReposManager.instance.doReposStarAction(
        reposOwner, reposName, state == ENABLE_STATE, (data) {
      if (view != null) {
        view.setStarState(
            state == ENABLE_STATE ? DISABLE_STATE : ENABLE_STATE, true);
      }
    }, (code, msg) {
      if (view != null) {
        view.setStarState(state, false);
      }
    });
  }

  @override
  void doRepossWatcherAction(reposOwner, reposName, int state) {
    ReposManager.instance.doRepossWatcherAction(
        reposOwner, reposName, state == ENABLE_STATE, (data) {
      if (view != null) {
        view.setWatchState(
            state == ENABLE_STATE ? DISABLE_STATE : ENABLE_STATE, true);
      }
    }, (code, msg) {
      if (view != null) {
        view.setWatchState(state, false);
      }
    });
  }

  @override
  void getBranches(reposOwner, reposName) {
    ReposManager.instance.getBranches(reposOwner, reposName, (data) {
      if (view != null) {
        view.setBranches(_getBranchBeanList(data));
      }
    }, (code, msg) {});
  }

  List<BranchBean> _getBranchBeanList(List<dynamic> list) {
    List<BranchBean> result = [];
    list.forEach((item) {
      result.add(BranchBean.fromJson(item));
    });
    return result;
  }
}
