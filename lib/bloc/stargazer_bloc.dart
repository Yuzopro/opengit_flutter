import 'package:open_git/bloc/user_bloc.dart';
import 'package:open_git/manager/user_manager.dart';

class StargazerBloc extends UserBloc {
  final String url;

  StargazerBloc(this.url) : super('');

  @override
  fetchList(int page) async {
    return await UserManager.instance.getStargazers(url, page);
  }

}