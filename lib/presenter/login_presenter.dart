import 'package:open_git/contract/login_contract.dart';
import 'package:open_git/manager/login_manager.dart';

class LoginPresenter extends ILoginPresenter {
  @override
  void login(String name, String password) async {
    if (view != null) {
      view.showLoading();
    }
    final response = await LoginManager.instance.login(name, password);
    if (view != null) {
      view.hideLoading();
      if (response != null) {
        view.onLoginSuccess();
      } else {
        view.showToast("登录失败");
      }
    }
  }
}
