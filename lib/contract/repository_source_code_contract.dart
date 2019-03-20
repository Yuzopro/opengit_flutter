import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_view.dart';

abstract class IRepositorySourceCodePresenter<
    V extends IRepositorySourceCodeView> extends BasePresenter<V> {
  getFileAsStream(url);
}

abstract class IRepositorySourceCodeView extends IBaseView {
  void getReposSourceCodeSuccess(data, isMarkdown);
}
