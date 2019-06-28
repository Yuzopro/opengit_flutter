import 'package:open_git/redux/app_state.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:redux/redux.dart';

typedef OnNext = void Function(String file);

class ReposSourceCodePageViewModel {
  final LoadingStatus status;
  final String data;
  final bool isImage;
  final bool isMarkdown;

  ReposSourceCodePageViewModel(
      {this.status, this.data, this.isImage, this.isMarkdown});

  static ReposSourceCodePageViewModel fromStore(Store<AppState> store) {
    return ReposSourceCodePageViewModel(
      status: store.state.reposSourceCodeState.status,
      data: store.state.reposSourceCodeState.data,
      isImage: store.state.reposSourceCodeState.isImage,
      isMarkdown: store.state.reposSourceCodeState.isMarkdown,
    );
  }
}
