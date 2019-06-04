import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';
import 'package:open_git/bean/juejin_bean.dart';

abstract class IHomePresenter<V extends IHomeView> extends BasePresenter<V> {
  getJueJinList(int page, bool isFromMore);
}

abstract class IHomeView extends IBasePullListView<Entrylist> {
}