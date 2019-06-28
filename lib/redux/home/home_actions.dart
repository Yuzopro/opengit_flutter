import 'package:flutter/widgets.dart';
import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/refresh_status.dart';

class RequestingHomesAction {}

class ReceivedHomesAction {
  ReceivedHomesAction(this.homes, this.refreshStatus);

  final List<Entrylist> homes;
  final RefreshStatus refreshStatus;
}

class FetchHomeAction {
  final BuildContext context;

  FetchHomeAction(this.context);
}

class ErrorLoadingHomesAction {}
