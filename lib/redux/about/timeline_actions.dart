import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/ui/status/refresh_status.dart';

class RequestingTimelinesAction {}

class ReceivedTimelinesAction {
  ReceivedTimelinesAction(this.releases, this.refreshStatus);

  final List<ReleaseBean> releases;
  final RefreshStatus refreshStatus;
}

class ErrorLoadingTimelinesAction {}
