import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/presenter/search_presenter.dart';

class SearchUserPresenter extends SearchPresenter {
  @override
  void dealResult(data, isFromMore) {
    if (data != null && data.length > 0) {
      List<UserBean> list = new List();
      var items = data["items"];
      for (int i = 0; i < items.length; i++) {
        var dataItem = items[i];
        UserBean user = UserBean.fromJson(dataItem);
        list.add(user);
      }
      if (view != null) {
        view.setList(list, isFromMore);
      }
    }
  }
}
