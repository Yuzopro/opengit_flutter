import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_view.dart';
import 'package:open_git/util/common_util.dart';

abstract class BaseState<T extends StatefulWidget, P extends BasePresenter<V>,
    V extends IBaseView> extends State<T> implements IBaseView {
  String title = "";

  P presenter;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  P initPresenter();

  Widget buildBody(BuildContext context);

  void initData() {
    this.title = getTitle();
  }

  String getTitle() {
    return "";
  }

  @override
  void initState() {
    super.initState();
    presenter = initPresenter();
    if (presenter != null) {
      presenter.onAttachView(this);
    }
    initData();
  }

  @override
  void dispose() {
    super.dispose();
    if (presenter != null) {
      presenter.onDetachView();
      presenter = null;
    }
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: title.isEmpty
          ? null
          : new AppBar(
              actions: getActions(),
              title: new Text(title),
            ),
      body: buildBody(context),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  Widget buildFloatingActionButton() {
    return null;
  }

  List<Widget> getActions() {
    return null;
  }

  @override
  showToast(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  @override
  void showLoading() {
    if (!_isLoading) {
      _isLoading = true;
      CommonUtil.showLoadingDialog(context);
    }
  }

  @override
  void hideLoading() {
    if (_isLoading) {
      _isLoading = false;
      Navigator.of(context).pop();
    }
  }

  Widget buildLoading() {
    return new Center(
      child: new Container(
        width: 200.0,
        height: 200.0,
        padding: new EdgeInsets.all(4.0),
        decoration: new BoxDecoration(
          color: Colors.transparent,
          //用一个BoxDecoration装饰器提供背景图片
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
                child: SpinKitCircle(
              color: Colors.black,
              size: 25.0,
            )),
            new Container(height: 10.0),
            new Container(
                child: new Text(
              "加载中...",
              style: new TextStyle(color: Colors.black),
            )),
          ],
        ),
      ),
    );
  }
}
