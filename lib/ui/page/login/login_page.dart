import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/login/login_action.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/page/login/sign_page.dart';
import 'package:open_git/util/common_util.dart';
import 'package:redux/redux.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginPageViewModel>(
      distinct: true,
      converter: (store) => LoginPageViewModel.fromStore(store, context),
      builder: (_, viewModel) => SignPage(viewModel),
    );
  }
}

class LoginPageContent extends StatefulWidget {
  final LoginPageViewModel viewModel;

  LoginPageContent(this.viewModel);

  @override
  State<StatefulWidget> createState() {
    return _LoginPageContentState();
  }
}

class _LoginPageContentState extends State<LoginPageContent> {
  TextEditingController _nameController;
  TextEditingController _passwordController;

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Form(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 22.0),
            children: <Widget>[
              SizedBox(
                height: kToolbarHeight,
              ),
              _buildTitle(),
              _buildTitleLine(),
              SizedBox(height: 70.0),
              _buildNameTextField(),
              SizedBox(height: 30.0),
              _buildPasswordTextField(context),
              SizedBox(height: 60.0),
              _buildLoginButton(context),
            ],
          ),
        ),
        CommonUtil.getLoading(
            context, widget.viewModel.status == LoadingStatus.loading),
      ],
    ));
  }

  Align _buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            AppLocalizations.of(context).currentlocal.login,
            style: YZConstant.normalTextWhite,
          ),
          color: Colors.black,
          onPressed: _isValidLogin()
              ? () {
                  _login();
                }
              : null,
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  TextFormField _buildPasswordTextField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).currentlocal.password,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        ),
      ),
      maxLines: 1,
      obscureText: _obscureText,
    );
  }

  TextFormField _buildNameTextField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).currentlocal.account,
        suffixIcon: GestureDetector(
          onTap: () {
            _nameController.clear();
          },
          child: Icon(_nameController.text.length > 0 ? Icons.clear : null),
        ),
      ),
      maxLines: 1,
    );
  }

  Padding _buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40.0,
          height: 2.0,
        ),
      ),
    );
  }

  Padding _buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        AppLocalizations.of(context).currentlocal.login,
        style: TextStyle(fontSize: 42.0),
      ),
    );
  }

  _isValidLogin() {
    String name = _nameController.text;
    String password = _passwordController.text;

    return name.length > 0 && password.length > 0;
  }

  _login() {
    String name = _nameController.text;
    String password = _passwordController.text;
    widget.viewModel.onLogin(name, password);
  }
}

typedef OnLogin = void Function(String name, String password);

class LoginPageViewModel {
  static final String TAG = "LoginPageViewModel";

  final OnLogin onLogin;
  final LoadingStatus status;

  LoginPageViewModel({this.onLogin, this.status});

  static LoginPageViewModel fromStore(
      Store<AppState> store, BuildContext context) {
    return LoginPageViewModel(
      status: store.state.loginState.status,
      onLogin: (String name, String password) {
        store.dispatch(FetchLoginAction(context, name, password));
      },
    );
  }
}
