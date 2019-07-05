import 'package:open_git/mvp/base/i_base_presenter.dart';
import 'package:open_git/mvp/base/i_base_view.dart';

abstract class BasePresenter<V extends IBaseView> extends IBasePresenter<V> {
  V view;

  @override
  void onAttachView(IBaseView view) {
    this.view = view;
  }

  @override
  void onDetachView() {
    this.view = null;
  }
}
