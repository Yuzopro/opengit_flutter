import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/contract/repository_event_contract.dart';
import 'package:open_git/manager/repos_manager.dart';

class RepositoryEventPresenter extends IRepositoryEventPresenter {
  @override
  getReposEvent(reposOwner, reposName, int page, bool isFromMore) async {
//    return ReposManager.instance.getReposEvents(reposOwner, reposName, page,
//        (data) {
//      if (data != null && data.length > 0) {
//        List<EventBean> list = new List();
//        for (int i = 0; i < data.length; i++) {
//          var dataItem = data[i];
//          list.add(EventBean.fromJson(dataItem));
//        }
//        if (view != null) {
//          view.setList(list, isFromMore);
//        }
//      }
//    }, (code, msg) {
//      print("code is $code @msg is $msg");
//    });
    final response = await ReposManager.instance.getReposEvents(reposOwner, reposName, page);
    if (view != null) {
      view.setList(response, isFromMore);
    }
    return response;
  }
}
