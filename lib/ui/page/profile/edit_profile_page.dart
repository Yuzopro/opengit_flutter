import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/manager/user_manager.dart';
import 'package:open_git/util/common_util.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfilePage> {
  UserBean _userBean;

  bool _isLoading = false;

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _blog = TextEditingController();
  TextEditingController _company = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _bio = TextEditingController();

  @override
  void initState() {
    super.initState();

    _userBean = LoginManager.instance.getUserBean();

    _name = TextEditingController.fromValue(
        TextEditingValue(text: _userBean.name ?? ''));
    _email = TextEditingController.fromValue(
        TextEditingValue(text: _userBean.email ?? ''));
    _blog = TextEditingController.fromValue(
        TextEditingValue(text: _userBean.blog ?? ''));
    _company = TextEditingController.fromValue(
        TextEditingValue(text: _userBean.company ?? ''));
    _location = TextEditingController.fromValue(
        TextEditingValue(text: _userBean.location ?? ''));
    _bio = TextEditingController.fromValue(
        TextEditingValue(text: _userBean.bio ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonUtil.getAppBar('编辑资料'),
      body: Stack(
        children: <Widget>[
          _buildBody(),
          CommonUtil.getLoading(context, _isLoading),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _editProfile();
        },
        backgroundColor: Colors.black,
        tooltip: 'edit profile',
        child: Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _postCard(context),
    );
  }

  Widget _postCard(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: ListView(
        children: <Widget>[
          _inputText(_name, Icons.person, '名字', '你的Github名字'),
          _inputText(_email, Icons.email, '邮箱', '你的Email'),
          _inputText(_blog, Icons.link, '博客', '你的Blog'),
          _inputText(_company, Icons.view_compact, '公司', '你的公司名'),
          _inputText(_location, Icons.location_on, '所在地', '你的所在位置'),
          _inputText(_bio, Icons.info, '简介', '你的个人介绍'),
        ],
      ),
    );
  }

  Widget _inputText(TextEditingController controller, iconData,
          String labelText, String hintText) =>
      Padding(
        padding: EdgeInsets.all(8.0),
        child: TextFormField(
          style: YZStyle.middleText,
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: YZStyle.middleSubText,
            hintText: hintText,
            hintStyle: YZStyle.middleSubText,
            prefixIcon: Icon(iconData),
            border: InputBorder.none,
          ),
          maxLines: 1,
        ),
      );

  void _editProfile() async {
    String name = _name.text;
    String email = _email.text;
    String blog = _blog.text;
    String company = _company.text;
    String location = _location.text;
    String bio = _bio.text;

    if (TextUtil.equals(name, _userBean.name) &&
        TextUtil.equals(email, _userBean.email) &&
        TextUtil.equals(blog, _userBean.blog) &&
        TextUtil.equals(company, _userBean.company) &&
        TextUtil.equals(location, _userBean.location) &&
        TextUtil.equals(bio, _userBean.bio)) {
      ToastUtil.showMessgae('没有进行任何修改，请重新操作');

      return;
    }

    _showLoading();
    var response = await UserManager.instance
        .updateProfile(name, email, blog, company, location, bio);
    if (response != null && response.result) {
      _userBean.name = name;
      _userBean.email = email;
      _userBean.blog = blog;
      _userBean.company = company;
      _userBean.location = location;
      _userBean.bio = bio;

      LoginManager.instance.setUserBean(_userBean.toJson, true);
      Navigator.pop(context);
    } else {
      ToastUtil.showMessgae('操作失败，请重试');
    }
    _hideLoading();
  }

  _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }
}
