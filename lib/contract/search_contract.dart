import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';

abstract class ISearchPresenter<T, V extends IBasePullListView<T>>
    extends BasePresenter<V> {
  search(type, query, page, isFromMore);
}