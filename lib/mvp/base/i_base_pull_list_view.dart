import 'package:open_git/mvp/base/i_base_view.dart';

abstract class IBasePullListView<T> implements IBaseView {
 void setList(List<T> list, bool isFromMore);
}