import 'package:flutter/widgets.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/org_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/user_manager.dart';

class OrgBloc extends BaseListBloc<OrgBean> {
  final String name;

  bool _isInit = false;

  OrgBloc(this.name);

  @override
  PageType getPageType() => PageType.profile_orgs;

  @override
  void initData(BuildContext context) {
    if (_isInit) {
      return;
    }
    _isInit = true;

    onReload();
  }

  @override
  Future getData() async {
    await _fetchProfile();
  }

  @override
  void onReload() async {
    showLoading();
    await _fetchProfile();
    hideLoading();
  }

  Future _fetchProfile() async {
    final result = await UserManager.instance.getOrgs(name, page);
    if (bean.data == null) {
      bean.data = List();
    }
    if (page == 1) {
      bean.data.clear();
    }

    noMore = true;
    if (result != null) {
      bean.isError = false;
      noMore = result.length != Config.PAGE_SIZE;
      bean.data.addAll(result);
    } else {
      bean.isError = true;
    }

    sink.add(bean);

    sink.add(bean);
  }
}
