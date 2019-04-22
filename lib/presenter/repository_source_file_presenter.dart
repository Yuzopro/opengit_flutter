import 'package:open_git/contract/repository_source_file_contract.dart';
import 'package:open_git/manager/repos_manager.dart';

class RepositorySourceFilePresenter extends IRepositorySourceFilePresenter {
  @override
  getReposFileDir(reposOwner, reposName, path) async {
//    return ReposManager.instance.getReposFileDir(reposOwner, reposName, (data) {
//      if (data != null && data.length > 0) {
//        List<SourceFileBean> dirs = new List();
//        List<SourceFileBean> files = new List();
//        for (int i = 0; i < data.length; i++) {
//          SourceFileBean file = SourceFileBean.fromJson(data[i]);
//          if (file.type == "file") {
//            files.add(file);
//          } else {
//            dirs.add(file);
//          }
//        }
//        List<SourceFileBean> list = new List();
//        list.addAll(dirs);
//        list.addAll(files);
//        if (view != null) {
//          view.setList(list, false);
//        }
//      }
//    }, (code, msg) {}, path: path);
    final response = await ReposManager.instance
        .getReposFileDir(reposOwner, reposName, path: path);
    if (response != null && view != null) {
      view.setList(response, false);
    }
  }
}
