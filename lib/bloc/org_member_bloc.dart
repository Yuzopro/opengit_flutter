import 'package:flutter_base_ui/bloc/page_type.dart';
import 'package:open_git/bloc/follow_bloc.dart';
import 'package:open_git/manager/user_manager.dart';

class OrgMemberBloc extends FollowBloc {
  OrgMemberBloc(String userName) : super(userName);

  @override
  PageType getPageType() {
    return PageType.org_member;
  }

  @override
  fetchList(int page) async {
    return await UserManager.instance.getOrgMembers(userName, page);
  }
}
