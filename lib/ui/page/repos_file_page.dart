import 'package:flutter/material.dart';
import 'package:open_git/ui/base/base_list_stateless_widget.dart';
import 'package:open_git/bean/source_file_bean.dart';
import 'package:open_git/bloc/bloc_provider.dart';
import 'package:open_git/bloc/repos_file_bloc.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/util/file_size_util.dart';
import 'package:open_git/util/image_util.dart';

class ReposFilePage
    extends BaseListStatelessWidget<SourceFileBean, ReposFileBloc> {
  @override
  String getTitle(BuildContext context) {
    ReposFileBloc bloc = BlocProvider.of<ReposFileBloc>(context);
    return bloc.reposName;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: super.build(context),
      onWillPop: () {
        ReposFileBloc bloc = BlocProvider.of<ReposFileBloc>(context);
        int length = bloc.fileStack.length;
        if (length > 0) {
          bloc.fetchPreDir();
          return new Future.value(false);
        }
        return new Future.value(true);
      },
    );
  }

  @override
  bool enablePullUp() {
    return false;
  }

  @override
  ListPageType getListPageType() {
    return ListPageType.repos_source_file;
  }

  @override
  Widget getHeader(BuildContext context) {
    ReposFileBloc bloc = BlocProvider.of<ReposFileBloc>(context);
    return ListTile(
      title: Text(bloc.getHeaderPath()),
    );
  }

  @override
  Widget builderItem(BuildContext context, SourceFileBean item) {
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
    bool isImage = ImageUtil.isImageEnd(item.name);
    if (item.type == "dir") {
      ReposFileBloc bloc = BlocProvider.of<ReposFileBloc>(context);
      bloc.fetchNextDir(item.name);
    } else if (isImage) {
      NavigatorUtil.goPhotoView(context, item.name, item.htmlUrl + "?raw=true");
    } else {
      NavigatorUtil.goReposSourceCode(context, item.name,
          ImageUtil.isImageEnd(item.url) ? item.downloadUrl : item.url);
    }
  }
}
