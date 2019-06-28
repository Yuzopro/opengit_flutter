import 'package:flutter/widgets.dart';
import 'package:open_git/bean/release_bean.dart';

class RequestingUpdateAction {}

class ReceivedVersionAction {
  ReceivedVersionAction(this.version);

  final String version;
}

class FetchUpdateAction {
  final BuildContext context;

  FetchUpdateAction(this.context);
}

class ReceivedUpdateAction {
}

class ErrorLoadingUpdateAction {}
