import 'package:flutter_base_ui/bloc/page_type.dart';
import 'package:open_git/bloc/user_bloc.dart';
import 'package:open_git/manager/user_manager.dart';

class ContributorBloc extends UserBloc {
  final String url;

  ContributorBloc(this.url) : super('');

  @override
  PageType getPageType() {
    return PageType.repo_contributors;
  }

  @override
  fetchList(int page) async {
    return await UserManager.instance.getContributors(url, page);
  }
}
