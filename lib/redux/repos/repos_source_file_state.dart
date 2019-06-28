import 'package:open_git/bean/source_file_bean.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';

class ReposSourceFileState {
  final LoadingStatus status;
  final List<String> fileStack;
  final RefreshStatus refreshStatus;
  final List<SourceFileBean> files;

  ReposSourceFileState(
      {this.status, this.fileStack, this.refreshStatus, this.files});

  factory ReposSourceFileState.initial() {
    return ReposSourceFileState(
      status: LoadingStatus.idle,
      fileStack: [],
      refreshStatus: RefreshStatus.idle,
      files: [],
    );
  }

  ReposSourceFileState copyWith(
      {LoadingStatus status,
      List<String> fileStack,
      RefreshStatus refreshStatus,
      List<SourceFileBean> files}) {
    return ReposSourceFileState(
        status: status ?? this.status,
        fileStack: fileStack ?? this.fileStack,
        refreshStatus: refreshStatus ?? this.refreshStatus,
        files: files ?? this.files);
  }
}
