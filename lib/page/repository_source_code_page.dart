import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:open_git/base/base_state.dart';
import 'package:open_git/contract/repository_source_code_contract.dart';
import 'package:open_git/presenter/repository_source_code_presenter.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/markdown_util.dart';
import 'package:photo_view/photo_view.dart';

class RepositorySourceCodePage extends StatefulWidget {
  String title, url;

  RepositorySourceCodePage(this.title, this.url);

  @override
  State<StatefulWidget> createState() {
    return _RepositorySourceCodePage(title, url);
  }
}

class _RepositorySourceCodePage
    extends BaseState<RepositorySourceCodePresenter, IRepositorySourceCodeView>
    implements IRepositorySourceCodeView {
  String title, url;

  var _data;
  bool _isMarkdown;

  _RepositorySourceCodePage(this.title, this.url);

  @override
  void initData() {
    super.initData();
    if (presenter != null && !ImageUtil.isImageEnd(url)) {
      presenter.getFileAsStream(url);
    }
  }

  @override
  RepositorySourceCodePresenter initPresenter() {
    return new RepositorySourceCodePresenter();
  }

  @override
  String getTitle() {
    return title;
  }

  @override
  Widget buildBody(BuildContext context) {
    if (ImageUtil.isImageEnd(url)) {
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
    }

    if (_data == null) {
      return buildLoading();
    }
    if (_isMarkdown) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: MarkdownUtil.markdownBody(_data),
        ),
      );
    }
    return WebviewScaffold(
      url: _data,
    );
  }

  @override
  void getReposSourceCodeSuccess(data, isMarkdown) {
    setState(() {
      _data = data;
      _isMarkdown = isMarkdown;
    });
  }
}
