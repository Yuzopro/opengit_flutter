import 'package:open_git/bean/source_file_bean.dart';
import 'package:open_git/ui/status/refresh_status.dart';

class RequestingFilesAction {
}

class FetchReposFileAction {
  final String reposOwner;
  final String reposName;
  final RefreshStatus refreshStatus;

  FetchReposFileAction(this.reposOwner, this.reposName, this.refreshStatus);
}

class FetchNextAction {
  final String reposOwner;
  final String reposName;
  final String fileName;

  FetchNextAction(this.reposOwner, this.reposName, this.fileName);
}

class ReceivedFilesAction {
  final List<SourceFileBean> files;
  final RefreshStatus refreshStatus;

  ReceivedFilesAction(this.files, this.refreshStatus);
}

class FetchPreAction {
  final String reposOwner;
  final String reposName;

  FetchPreAction(this.reposOwner, this.reposName);
}

class PushFileAction {
  final String fileName;

  PushFileAction(this.fileName);
}

class PopFileAction {
}

class ErrorLoadingFilesAction {
}
