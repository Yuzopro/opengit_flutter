import 'package:flutter/material.dart';
import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_view.dart';

abstract class BaseState<P extends BasePresenter<V>, V extends IBaseView>
    extends State<StatefulWidget> implements IBaseView {
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
              centerTitle: true,
              title: new Text(title),
            ),
      body: buildBody(context),
    );
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
//      routePagerNavigator(context, new LoadingView());
    }
  }

  @override
  void hideLoading() {
    if (_isLoading) {
      _isLoading = false;
      Navigator.of(context).pop();
    }
  }
}
