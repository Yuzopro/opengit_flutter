import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_git/mvp/base/base_presenter.dart';
import 'package:open_git/mvp/base/i_base_view.dart';

abstract class BaseState<T extends StatefulWidget, P extends BasePresenter<V>,
    V extends IBaseView> extends State<T> implements IBaseView {
  String title = "";

  P presenter;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    return Scaffold(
      key: _scaffoldKey,
      appBar: title.isEmpty
          ? null
          : AppBar(
              actions: getActions(),
              title: Text(title),
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
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void showLoading() {
    if (!_isLoading) {
      _isLoading = true;
    }
  }

  @override
  void hideLoading() {
    if (_isLoading) {
      _isLoading = false;
    }
  }

  Widget buildLoading() {
    return Center(
      child: Container(
        width: 200.0,
        height: 200.0,
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          //用一个BoxDecoration装饰器提供背景图片
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: SpinKitCircle(
              color: Colors.black,
              size: 25.0,
            )),
            Container(height: 10.0),
            Container(
                child: Text(
              "加载中...",
              style: TextStyle(color: Colors.black),
            )),
          ],
        ),
      ),
    );
  }
}
