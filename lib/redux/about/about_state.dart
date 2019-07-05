import 'package:open_git/status/status.dart';

class AboutState {
  final LoadingStatus status;
  final String version;

  AboutState({this.status, this.version});

  factory AboutState.initial() {
    return AboutState(
      status: LoadingStatus.success,
      version: "",
    );
  }

  AboutState copyWith({LoadingStatus status, String version}) {
    return AboutState(
      status: status ?? this.status,
      version: version ?? this.version,
    );
  }
}
