import 'package:open_git/bean/source_file_bean.dart';
import 'package:open_git/ui/status/refresh_status.dart';

class RequestingCodeAction {}

class FetchReposCodeAction {
  final String url;

  FetchReposCodeAction(this.url);
}

class ReceivedCodeAction {
  final String data;
  final bool isImage;
  final bool isMarkdown;

  ReceivedCodeAction(this.data, this.isImage, this.isMarkdown);
}

class ErrorLoadingCodeAction {}
