import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/repos/repos_source_code_actions.dart';
import 'package:open_git/ui/repos/repos_source_code_page_view_model.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/util/markdown_util.dart';
import 'package:photo_view/photo_view.dart';

class ReposSourceCodePage extends StatelessWidget {
  final String title, url;

  ReposSourceCodePage(this.title, this.url);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ReposSourceCodePageViewModel>(
      distinct: true,
      onInit: (store) => store.dispatch(FetchReposCodeAction(url)),
      converter: (store) => ReposSourceCodePageViewModel.fromStore(store),
      builder: (_, viewModel) =>
          ReposSourceCodePageContent(viewModel, title, url),
    );
  }
}

class ReposSourceCodePageContent extends StatelessWidget {
  final ReposSourceCodePageViewModel viewModel;
  final String title;
  final String url;

  ReposSourceCodePageContent(this.viewModel, this.title, this.url);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Stack(
        children: <Widget>[
          _buildBody(),
          new Offstage(
            offstage: viewModel.status != LoadingStatus.loading,
            child: new Container(
              alignment: Alignment.center,
              child: new Center(
                child: SpinKitCircle(
                  color: Theme.of(context).primaryColor,
                  size: 25.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (viewModel.isImage) {
      return new Container(
        color: Colors.black,
        child: new PhotoView(
          imageProvider: new NetworkImage(url),
          loadingChild: Container(
            child: new Stack(
              children: <Widget>[
                new Center(
                    child: new SpinKitFoldingCube(
                        color: Colors.white, size: 60.0)),
              ],
            ),
          ),
        ),
      );
    } else if (viewModel.isMarkdown) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: MarkdownUtil.markdownBody(viewModel.data),
        ),
      );
    } else if (viewModel.data.length > 0) {
      return WebviewScaffold(
        url: viewModel.data,
      );
    } else {
      return new Container();
    }
  }
}
