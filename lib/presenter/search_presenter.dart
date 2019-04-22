import 'package:open_git/contract/search_contract.dart';
import 'package:open_git/manager/search_manager.dart';

abstract class SearchPresenter extends ISearchPresenter {
  void dealResult(data, isFromMore);

  @override
  search(type, query, page, isFromMore) async {
    final response = await SearchManager.instance.getIssue(type, query, page);
    if (response != null && response.result) {
      dealResult(response.data, isFromMore);
    }
    return response;
  }
}
