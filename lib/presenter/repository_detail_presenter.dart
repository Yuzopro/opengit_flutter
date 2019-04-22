import 'package:open_git/bean/branch_bean.dart';
import 'package:open_git/contract/repository_detail_contract.dart';
import 'package:open_git/manager/repos_manager.dart';

class RepositoryDetailPresenter extends IRepositoryDetailPresenter {
  static const int DEFAULT_STATE = 0;
  static const int ENABLE_STATE = 1;
  static const int DISABLE_STATE = 2;

  @override
  getReposDetail(reposOwner, reposName, bool isRefresh) async {
//    return ReposManager.instance.getReposDetail(reposOwner, reposName, (data) {
//      if (data != null && view != null) {
//        view.getReposDetailSuccess(Repository.fromJson(data), isRefresh);
//      }
//    }, (code, msg) {
//      print("code is $code @msg is $msg");
//    });
    final result =
        await ReposManager.instance.getReposDetail(reposOwner, reposName);
    if (result != null && view != null) {
      view.getReposDetailSuccess(result, isRefresh);
    }
    return result;
  }

  @override
  getReadme(reposFullName, branch) async {
//    ReposManager.instance.getReadme(reposFullName, branch, (data) {
//      if (data != null && view != null) {
//        view.setReadmeContent(data);
//      }
//    }, (code, msg) {
//      print("code is $code @msg is $msg");
//    });
    final result = await ReposManager.instance.getReadme(reposFullName, branch);
    if (result != null && view != null) {
      view.setReadmeContent(result);
    }
    return result;
  }

  @override
  getReposStar(reposOwner, reposName) async {
//    ReposManager.instance.getReposStar(reposOwner, reposName, (data) {
//      if (view != null) {
//        view.setStarState(ENABLE_STATE, false);
//      }
//    }, (code, msg) {
//      if (view != null) {
//        view.setStarState(DISABLE_STATE, false);
//      }
//    });
    final response =
        await ReposManager.instance.getReposStar(reposOwner, reposName);
    if (response != null && view != null) {
      view.setStarState(response.result ? ENABLE_STATE : DISABLE_STATE, false);
    }
    return response;
  }

  @override
  getReposWatcher(reposOwner, reposName) async {
//    ReposManager.instance.getReposWatcher(reposOwner, reposName, (data) {
//      if (view != null) {
//        view.setWatchState(ENABLE_STATE, false);
//      }
//    }, (code, msg) {
//      if (view != null) {
//        view.setWatchState(DISABLE_STATE, false);
//      }
//    });
    final response =
        await ReposManager.instance.getReposWatcher(reposOwner, reposName);
    if (response != null && view != null) {
      view.setWatchState(response.result ? ENABLE_STATE : DISABLE_STATE, false);
    }
    return response;
  }

  @override
  doReposStarAction(reposOwner, reposName, int state) async {
//    ReposManager.instance.doReposStarAction(
//        reposOwner, reposName, state == ENABLE_STATE, (data) {
//      if (view != null) {
//        view.setStarState(
//            state == ENABLE_STATE ? DISABLE_STATE : ENABLE_STATE, true);
//      }
//    }, (code, msg) {
//      if (view != null) {
//        view.setStarState(state, false);
//      }
//    });
    final response = await ReposManager.instance
        .doReposStarAction(reposOwner, reposName, state == ENABLE_STATE);
    if (response != null && view != null) {
      view.setStarState(
          response.result
              ? (state == ENABLE_STATE ? DISABLE_STATE : ENABLE_STATE)
              : state,
          response.result);
    }
    return response;
  }

  @override
  doRepossWatcherAction(reposOwner, reposName, int state) async {
//    ReposManager.instance.doRepossWatcherAction(
//        reposOwner, reposName, state == ENABLE_STATE, (data) {
//      if (view != null) {
//        view.setWatchState(
//            state == ENABLE_STATE ? DISABLE_STATE : ENABLE_STATE, true);
//      }
//    }, (code, msg) {
//      if (view != null) {
//        view.setWatchState(state, false);
//      }
//    });
    final response = await ReposManager.instance
        .doRepossWatcherAction(reposOwner, reposName, state == ENABLE_STATE);
    if (response != null && view != null) {
      view.setWatchState(
          response.result
              ? (state == ENABLE_STATE ? DISABLE_STATE : ENABLE_STATE)
              : state,
          response.result);
    }
    return response;
  }

  @override
  getBranches(reposOwner, reposName) async {
//    ReposManager.instance.getBranches(reposOwner, reposName, (data) {
//      if (view != null) {
//        view.setBranches(_getBranchBeanList(data));
//      }
//    }, (code, msg) {});
    final response = await ReposManager.instance.getBranches(reposOwner, reposName);
    if (response != null && view != null) {
      view.setBranches(response);
    }
    return response;
  }
}
