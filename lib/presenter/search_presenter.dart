import 'package:open_git/contract/search_contract.dart';
import 'package:open_git/manager/search_manager.dart';

abstract class SearchPresenter extends ISearchPresenter {
  void dealResult(data, isFromMore);

  @override
  search(type, query, page, isFromMore) {
    return SearchManager.instance.getIssue(type, query, page, (data) {
      dealResult(data, isFromMore);
    }, (code, msg) {});
  }
}
