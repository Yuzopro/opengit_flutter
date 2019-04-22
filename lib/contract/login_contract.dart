import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_view.dart';

abstract class ILoginPresenter<V extends ILoginView> extends BasePresenter<V> {
  void login(String name, String password);
}

abstract class ILoginView extends IBaseView {
  void onLoginSuccess();
}