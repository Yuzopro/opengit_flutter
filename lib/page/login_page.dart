import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_git/base/base_state.dart';
import 'package:open_git/contract/login_contract.dart';
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
  String getTitle() {
    return "登录";
  }

  @override
  Widget buildBody(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(top: 21.0, left: 20.0, right: 20.0),
      child: new ListView(
        //解决键盘弹起导致视图被挤压的问题
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _logoWidget(),
              //输入组件
              _inputWidget(),
              //登陆按钮
              _loginBtnWidget(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  LoginPresenter initPresenter() {
    return LoginPresenter();
  }

  Widget _logoWidget() {
    return new Image(
        width: 64.0,
        height: 64.0,
        image: new AssetImage('image/ic_welcome.png'));
  }

  Widget _inputWidget() {
    return new Form(
        autovalidate: true,
        child: new Column(
          children: <Widget>[
            //输入账号名
            _userNameWidget(),
            //输入密码
            _userPwdWidget(),
          ],
        ));
  }

  Widget _userNameWidget() {
    return new TextFormField(
      controller: _nameController,
      decoration: new InputDecoration(
        hintText: "你的Github账号",
        labelText: "用户名 *",
        icon: Icon(Icons.person),
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

  Widget _userPwdWidget() {
    return new TextFormField(
      controller: _passwordController,
      decoration: new InputDecoration(
        hintText: "你的Github账号密码",
        labelText: "密码 *",
        icon: Icon(Icons.lock),
        suffixIcon: new GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: new Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        ),
      ),
      maxLines: 1,
      obscureText: _obscureText,
    );
  }

  Widget _loginBtnWidget() {
    return new Container(
      margin: const EdgeInsets.only(top: 40.0),
      width: MediaQuery.of(context).size.width - 80,
      child: new FlatButton(
        color: Colors.black,
        highlightColor: Colors.black,
        colorBrightness: Brightness.dark,
        splashColor: Colors.grey,
        disabledColor: Colors.black45,
        child: Text(
          "登录",
          style: new TextStyle(
            color: Colors.white,
            fontSize: 17.0,
          ),
        ),
        onPressed: _isValidLogin()
            ? () {
                _login();
              }
            : null,
      ),
    );
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
}
