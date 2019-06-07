import 'package:flutter/material.dart';
import 'package:open_git/base/base_state.dart';
import 'package:open_git/contract/login_contract.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/presenter/login_presenter.dart';
import 'package:open_git/route/navigator_util.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends BaseState<LoginPage, LoginPresenter, ILoginView>
    implements ILoginView {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  bool _obscureText = true;

  @override
  void initData() {
    super.initData();
    _nameController.addListener(() {
      setState(() {});
    });
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
        body: Form(
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
    )));
  }

  @override
  LoginPresenter initPresenter() {
    return LoginPresenter();
  }

  _isValidLogin() {
    String name = _nameController.text;
    String password = _passwordController.text;

    return name.length > 0 && password.length > 0;
  }

  _login() {
    if (presenter != null) {
      String name = _nameController.text;
      String password = _passwordController.text;
      presenter.login(name, password);
    }
  }

  @override
  void onLoginSuccess() {
    NavigatorUtil.goMain(context);
  }

  Align _buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            AppLocalizations.of(context).currentlocal.login,
            style: Theme.of(context).primaryTextTheme.headline,
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
    return new TextFormField(
      controller: _passwordController,
      decoration: new InputDecoration(
        labelText: AppLocalizations.of(context).currentlocal.password,
        suffixIcon: new GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child:
              new Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        ),
      ),
      maxLines: 1,
      obscureText: _obscureText,
    );
  }

  TextFormField _buildNameTextField() {
    return new TextFormField(
      controller: _nameController,
      decoration: new InputDecoration(
        labelText: AppLocalizations.of(context).currentlocal.account,
        suffixIcon: new GestureDetector(
          onTap: () {
            setState(() {
              _nameController.clear();
            });
          },
          child: new Icon(_nameController.text.length > 0 ? Icons.clear : null),
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
}
