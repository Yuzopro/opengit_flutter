import 'package:flutter/widgets.dart';

class RequestingUpdateAction {}

class ReceivedVersionAction {
  ReceivedVersionAction(this.version);

  final String version;
}

class FetchVersionAction {
}

class FetchUpdateAction {
  final BuildContext context;

  FetchUpdateAction(this.context);
}

class ReceivedUpdateAction {
}

class ErrorLoadingUpdateAction {}
