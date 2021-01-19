import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/common/gradient_const.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/page/login/login_page.dart';
import 'package:open_git/ui/widget/signup_arrow_button.dart';
import 'package:open_git/util/common_util.dart';

class SignPage extends StatefulWidget {
  final LoginPageViewModel viewModel;

  SignPage(this.viewModel);

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildBody(),
          CommonUtil.getLoading(
              context, widget.viewModel.status == LoadingStatus.loading),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final _media = MediaQuery.of(context).size;

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 60.0, horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Image.asset(
                          ImagePath.image_app,
                          height: _media.height / 7,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        AppLocalizations.of(context).currentlocal.sign_tip_1,
                        style: YZStyle.largeTextBold,
                      ),
                      SizedBox(height: 30),
                      Text(
                        AppLocalizations.of(context).currentlocal.sign_tip_2,
                        style: YZStyle.largeLargeText,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: _media.height / 3.8,
                        decoration: BoxDecoration(
                          gradient: SIGNUP_CARD_BACKGROUND,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: _inputText(
                                  _username,
                                  AppLocalizations.of(context)
                                      .currentlocal
                                      .account,
                                  GestureDetector(
                                    onTap: () {
                                      _username.clear();
                                      setState(() {});
                                    },
                                    child: Icon(_username.text.length > 0
                                        ? Icons.clear
                                        : null),
                                  ),
                                  false,
                                ),
                              ),
                              Divider(
                                height: 5,
                                color: Colors.black,
                              ),
                              Expanded(
                                child: _inputText(
                                  _password,
                                  AppLocalizations.of(context)
                                      .currentlocal
                                      .password,
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child: Icon(_obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  _obscureText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).currentlocal.sign_text,
                      style: YZStyle.smallText,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        NavigatorUtil.goWebView(
                            context,
                            AppLocalizations.of(context).currentlocal.sign_up,
                            'https://github.com/');
                      },
                      child: Text(
                        AppLocalizations.of(context).currentlocal.sign_up,
                        style: YZStyle.smallText
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    widget.viewModel.onAuth();
                  },
                  child: Text(
                    "授权登录",
                    style: YZStyle.middleText
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
            Positioned(
              bottom: _media.height / 6.3,
              right: 15,
              child: SignUpArrowButton(
                icon: IconData(0xe901, fontFamily: 'Icons'),
                iconSize: 9,
                onTap: () {
                  _login();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputText(TextEditingController controller, String labelText,
          Widget suffixIcon, bool obSecure) =>
      TextFormField(
        style: TextStyle(height: 1.3),
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: YZStyle.smallTextSize,
            fontFamily: YZFonts.montserrat_font_family,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
            height: 0,
          ),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
        maxLines: 1,
        obscureText: obSecure,
      );

  _login() {
    String name = _username.text;
    String password = _password.text;
    if (TextUtil.isEmpty(name) || TextUtil.isEmpty(password)) {
      ToastUtil.showMessgae('账号和密码不能为空');
      return;
    }
    widget.viewModel.onLogin(name, password);
  }
}
