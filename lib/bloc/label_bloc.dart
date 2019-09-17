import 'package:flutter/widgets.dart';
import 'package:flutter_base_ui/bloc/base_list_bloc.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/label_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/issue_manager.dart';
import 'package:open_git/manager/login_manager.dart';

class LabelBloc extends BaseListBloc<Labels> {
  static final String TAG = "LabelBloc";

  final String repo;
  final int issueNum;
  List<Labels> labels;

  String owner;

  LabelBloc(this.repo, this.labels, this.issueNum) {
    UserBean userBean = LoginManager.instance.getUserBean();
    owner = userBean?.login;
  }

  void initData(BuildContext context) async {
    onReload();
  }

  void createLabel(Labels label) {
    if (label == null) {
      return;
    }
    if (bean.data != null) {
      bean.data.insert(0, label);
      notifyDataChanged();
    }
  }

  void updateLabel(Labels label) {
    if (label == null) {
      return;
    }
    int deleteIndex = -1;
    if (bean.data != null) {
      for (int i = 0; i < bean.data.length; i++) {
        Labels item = bean.data[i];
        if (label.id == -1) {
          if (TextUtil.equals(label.name, item.name)) {
            deleteIndex = i;
          }
        } else if (label.id == item.id) {
          item.name = label.name;
          item.color = label.color;
          item.description = label.description;
          break;
        }
      }
      if (deleteIndex != -1) {
        bean.data.removeAt(deleteIndex);
      }
      notifyDataChanged();
    }
  }

  void addIssueLabel(Labels label) async {
    showLoading();

    var result = await IssueManager.instance
        .addIssueLabel(owner, repo, issueNum, label.name);
    if (result != null && result.result) {
      if (labels == null) {
        labels = [];
      }
      labels.add(label);
    } else {
      ToastUtil.showMessgae('操作失败，请重试');
    }

    hideLoading();
  }

  void deleteIssueLabel(String name) async {
    showLoading();
    var result = await IssueManager.instance
        .deleteIssueLabel(owner, repo, issueNum, name);
    if (result != null && result.result) {
      if (labels != null) {
        int deleteIndex = -1;
        for (int i = 0; i < labels.length; i++) {
          Labels item = labels[i];
          if (TextUtil.equals(item.name, name)) {
            deleteIndex = i;
          }
        }
        if (deleteIndex != null) {
          labels.removeAt(deleteIndex);
        }
      }
    } else {
      ToastUtil.showMessgae('操作失败，请重试');
    }
    hideLoading();
  }

  @override
  void onReload() async {
    showLoading();
    await _fetchLabelList();
    hideLoading();
  }

  @override
  Future getData() async {
    await _fetchLabelList();
  }

  Future _fetchLabelList() async {
    LogUtil.v('_fetchLabelList', tag: TAG);
    try {
      var result = await IssueManager.instance.getLabel(owner, repo, page);
      if (bean.data == null) {
        bean.data = List();
      }
      if (page == 1) {
        bean.data.clear();
      }

      noMore = true;
      if (result != null) {
        bean.isError = false;
        noMore = result.length != Config.PAGE_SIZE;
        bean.data.addAll(result);
      } else {
        bean.isError = true;
      }

    } catch (_) {
      if (page != 1) {
        page--;
      }
    }
  }
}
