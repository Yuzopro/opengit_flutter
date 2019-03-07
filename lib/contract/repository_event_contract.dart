import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';
import 'package:open_git/bean/event_bean.dart';

abstract class IRepositoryEventPresenter<V extends IRepositoryEventView>
    extends BasePresenter<V> {
  getReposEvent(reposOwner, reposName, int page, bool isFromMore);
}

abstract class IRepositoryEventView extends IBasePullListView<EventBean> {
}
