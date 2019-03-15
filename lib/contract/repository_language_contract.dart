import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';
import 'package:open_git/bean/repos_bean.dart';

abstract class IRepositoryLanguagePresenter<V extends IRepositoryLanguageView>
    extends BasePresenter<V> {
  getLanguages(language, page, isFromMore);
}

abstract class IRepositoryLanguageView extends IBasePullListView<Repository> {
}
