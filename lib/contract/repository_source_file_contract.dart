import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';
import 'package:open_git/bean/source_file_bean.dart';

abstract class IRepositorySourceFilePresenter<
    V extends IRepositorySourceFileView> extends BasePresenter<V> {
  getReposFileDir(userName, reposName, path);
}

abstract class IRepositorySourceFileView extends IBasePullListView<SourceFileBean> {
}
