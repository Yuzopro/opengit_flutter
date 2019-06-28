import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/bean/source_file_bean.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/repos/repos_source_file_actions.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/ui/repos/repos_source_file_page_view_model.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:open_git/ui/widget/yz_pull_refresh_list.dart';
import 'package:open_git/util/file_size_util.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/log_util.dart';

class ReposSourceFilePage extends StatelessWidget {
  final String reposOwner, reposName;

  ReposSourceFilePage(this.reposOwner, this.reposName);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ReposSourceFilePageViewModel>(
      distinct: true,
      onInit: (store) => store.dispatch(
          FetchReposFileAction(reposOwner, reposName, RefreshStatus.idle)),
      converter: (store) =>
          ReposSourceFilePageViewModel.fromStore(store, reposOwner, reposName),
      builder: (_, viewModel) =>
          ReposSourceFilePageContent(viewModel, reposOwner, reposName),
    );
  }
}

class ReposSourceFilePageContent extends StatelessWidget {
  static final String TAG = "ReposSourceFilePageContent";

  ReposSourceFilePageContent(this.viewModel, this.reposOwner, this.reposName);

  final ReposSourceFilePageViewModel viewModel;
  final String reposOwner;
  final String reposName;

  @override
  Widget build(BuildContext context) {
    LogUtil.v('build', tag: TAG);
    return new WillPopScope(
        child: new YZPullRefreshList(
          title: reposName,
          status: viewModel.status,
          refreshStatus: viewModel.refreshStatus,
          itemCount: viewModel.files == null ? 1 : viewModel.files.length + 1,
          onRefreshCallback: viewModel.onRefresh,
          enablePullUp: false,
          itemBuilder: (context, index) {
            if (index == 0) {
              return getHeader();
            } else {
              return _buildItem(context, viewModel.files[index - 1]);
            }
          },
        ),
        onWillPop: viewModel.onWillPop);
  }

  Widget getHeader() {
    return ListTile(
      title: Text(_getHeaderPath()),
    );
  }

  String _getHeaderPath() {
    int length = viewModel.fileStack.length;
    String headerPath = "";
    for (int i = 0; i < length; i++) {
      headerPath += ("/" + viewModel.fileStack[i]);
    }
    return reposName + headerPath;
  }

  Widget _buildItem(BuildContext context, SourceFileBean item) {
    return ListTile(
      leading: Icon(item.type == "file" ? Icons.attach_file : Icons.folder),
      title: Text(item.name),
      subtitle: item.type == "file"
          ? Text(FileSizeUtil.formetFileSize(item.size))
          : null,
      onTap: () {
        _onItemClick(context, item);
      },
    );
  }

  void _onItemClick(BuildContext context, SourceFileBean item) {
    if (item.type == "dir") {
      viewModel.onNext(item.name);
    } else {
      NavigatorUtil.goReposSourceCode(context, item.name,
          ImageUtil.isImageEnd(item.url) ? item.downloadUrl : item.url);
    }
  }
}
