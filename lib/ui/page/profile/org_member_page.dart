import 'package:flutter/widgets.dart';
import 'package:open_git/ui/page/profile/user_page.dart';

class OrgMemberPage extends UserPage {

  @override
  bool isShowAppBar() {
    return false;
  }

  @override
  String getTitle(BuildContext context) {
    return '成员';
  }
}
