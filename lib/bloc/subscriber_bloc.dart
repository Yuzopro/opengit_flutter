import 'package:open_git/bloc/user_bloc.dart';
import 'package:open_git/manager/user_manager.dart';

class SubscriberBloc extends UserBloc {
  final String url;

  SubscriberBloc(this.url) : super('');

  @override
  fetchList(int page) async {
    return await UserManager.instance.getSubscribers(url, page);
  }
}
