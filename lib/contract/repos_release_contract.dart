import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_view.dart';
import 'package:open_git/bean/release_bean.dart';

abstract class IReposReleasePresenter<V extends IReposReleaseView>
    extends BasePresenter<V> {
  getReposReleases(userName, repos, {isShowLoading = true});
  compareVersion(String localVersion, String serverVersion);
}

abstract class IReposReleaseView extends IBaseView {
  void getReposReleasesSuccess(List<ReleaseBean> list);
}
