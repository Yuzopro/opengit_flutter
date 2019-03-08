import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_view.dart';
import 'package:open_git/bean/trending_bean.dart';

abstract class IRepositoryTrendingPresenter<V extends IRepositoryTrendingView>
    extends BasePresenter<V> {
  getReposTrending(since, TrendingType);
}

abstract class IRepositoryTrendingView extends IBaseView {
  void setTrendingList(List<TrendingBean> list);
}
