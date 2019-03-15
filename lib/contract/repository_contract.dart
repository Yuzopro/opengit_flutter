import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';
import 'package:open_git/bean/repos_bean.dart';

abstract class IRepositoryPresenter<V extends IRepositoryView> extends BasePresenter<V> {
  getUserRepos(int page, bool isStar, bool isFromMore);
}

abstract class IRepositoryView extends IBasePullListView<Repository> {
}