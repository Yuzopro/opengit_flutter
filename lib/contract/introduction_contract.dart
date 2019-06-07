import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';
import 'package:open_git/bean/release_bean.dart';

abstract class IIntroductionPresenter<V extends IIntroductionView>
    extends BasePresenter<V> {
  getReposReleases(userName, repos, int page, bool isFromMore);
}

abstract class IIntroductionView extends IBasePullListView<ReleaseBean> {}
