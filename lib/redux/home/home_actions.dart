import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/refresh_status.dart';

class RequestingHomesAction {}

class ReceivedHomesAction {
  ReceivedHomesAction(this.homes, this.refreshStatus);

  final List<Entrylist> homes;
  final RefreshStatus refreshStatus;
}

class UpdateDialogAction {
  final ReleaseBean releaseBean;

  UpdateDialogAction(this.releaseBean);
}

class ErrorLoadingHomesAction {}
