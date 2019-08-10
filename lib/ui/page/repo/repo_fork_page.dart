import 'package:flutter/widgets.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/ui/page/profile/user_page.dart';

class RepoForkPage extends UserPage {
  @override
  PageType getPageType() {
    return PageType.repo_fork;
  }

  @override
  String getTitle(BuildContext context) {
    return 'Forks';
  }
}
