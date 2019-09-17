import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/org_bean.dart';
import 'package:open_git/manager/user_manager.dart';

class OrgProfileBloc extends BaseBloc<LoadingBean<OrgBean>> {
  final String org;

  OrgProfileBloc(this.org) {
    bean = new LoadingBean(isLoading: false);
  }

  @override
  void initData(BuildContext context) {
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
    final result = await UserManager.instance.getOrgProfile(org);
    bean.data = result;

    if (result == null) {
      bean.isError = true;
    } else {
      bean.isError = false;
    }
  }
}
