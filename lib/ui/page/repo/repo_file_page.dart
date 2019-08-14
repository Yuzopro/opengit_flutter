import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_stateless_widget.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/bloc/loading_bean.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/source_file_bean.dart';
import 'package:open_git/bloc/repos_file_bloc.dart';
import 'package:open_git/route/navigator_util.dart';

class RepoFilePage
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
          return Future.value(false);
        }
        return Future.value(true);
      },
    );
  }

  @override
  bool isLoading(LoadingBean<List<SourceFileBean>> data) {
    return data != null ? data.isLoading : true;
  }

  @override
  bool enablePullUp() {
    return false;
  }

  @override
  PageType getPageType() {
    return PageType.repos_source_file;
  }

  @override
  Widget getHeader(
      BuildContext context, LoadingBean<List<SourceFileBean>> data) {
    ReposFileBloc bloc = BlocProvider.of<ReposFileBloc>(context);
    return ListTile(
      title: Text(bloc.getHeaderPath(), style: YZStyle.middleText),
    );
  }

  @override
  Widget builderItem(BuildContext context, SourceFileBean item) {
    return ListTile(
      leading: Icon(item.type == "file" ? Icons.attach_file : Icons.folder),
      title: Text(item.name, style: YZStyle.middleText),
      subtitle:
          item.type == "file" ? Text(FileUtil.formatFileSize(item.size)) : null,
      onTap: () {
        _onItemClick(context, item);
      },
    );
  }

  void _onItemClick(BuildContext context, SourceFileBean item) {
    bool isImage = ImageUtil.isImage(item.name);
    if (item.type == "dir") {
      ReposFileBloc bloc = BlocProvider.of<ReposFileBloc>(context);
      bloc.fetchNextDir(item.name);
    } else if (isImage) {
      NavigatorUtil.goPhotoView(context, item.name, item.htmlUrl + "?raw=true");
    } else {
      NavigatorUtil.goReposSourceCode(context, item.name,
          ImageUtil.isImage(item.url) ? item.downloadUrl : item.url);
    }
  }
}
