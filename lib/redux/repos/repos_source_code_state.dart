import 'package:open_git/ui/status/loading_status.dart';

class ReposSourceCodeState {
  final LoadingStatus status;
  final String data;
  final bool isImage;
  final bool isMarkdown;

  ReposSourceCodeState({this.status, this.data, this.isImage, this.isMarkdown});

  factory ReposSourceCodeState.initial() {
    return ReposSourceCodeState(
      status: LoadingStatus.idle,
      data: '',
      isImage: false,
      isMarkdown: false,
    );
  }

  ReposSourceCodeState copyWith(
      {LoadingStatus status, String data, bool isImage, bool isMarkdown}) {
    return ReposSourceCodeState(
        status: status ?? this.status,
        data: data ?? this.data,
        isImage: isImage ?? this.isImage,
        isMarkdown: isMarkdown ?? this.isMarkdown);
  }
}
