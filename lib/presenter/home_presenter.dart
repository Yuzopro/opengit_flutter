import 'package:open_git/contract/home_contract.dart';
import 'package:open_git/manager/juejin_manager.dart';

class HomePresenter extends IHomePresenter {
  @override
  getJueJinList(int page, bool isFromMore) async {
    final result = await JueJinManager.instance.getJueJinList(page);
    if (view != null) {
      view.setList(result, isFromMore);
    }
    return result;
  }
}
