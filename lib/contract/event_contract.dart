import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';
import 'package:open_git/bean/event_bean.dart';

abstract class IEventPresenter<V extends IEventView> extends BasePresenter<V> {
  getEventReceived(userName, page, isFromMore);
  getEvent(userName, page, isFromMore);
}

abstract class IEventView extends IBasePullListView<EventBean> {}
