import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/label_bean.dart';
import 'package:open_git/bloc/label_bloc.dart';
import 'package:open_git/manager/issue_manager.dart';
import 'package:open_git/route/navigator_util.dart';

class LabelPage extends BaseListStatelessWidget<Labels, LabelBloc> {
  @override
  PageType getPageType() {
    return PageType.issue_label;
  }

  @override
  String getTitle(BuildContext context) {
    return '标签';
  }

  @override
  List<Widget> getAction(BuildContext context) {
    return [
      InkWell(
        child: Container(
          width: 56,
          height: 56,
          child: Icon(Icons.add),
        ),
        onTap: () {
          _editLabel(context, null);
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: super.build(context),
      onWillPop: () {
        LabelBloc bloc = BlocProvider.of<LabelBloc>(context);
        IssueManager.instance.setLabels(bloc.labels);
        return Future.value(true);
      },
    );
  }

  @override
  Widget builderItem(BuildContext context, Labels item) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _postCard(context, item),
      ),
      onTap: () {
        _editLabel(context, item);
      },
    );
  }

  Widget _postCard(BuildContext context, Labels item) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _profileColumn(context, item),
      ),
    );
  }

  Widget _profileColumn(BuildContext context, Labels item) {
    List<Widget> _list = [];
    _list.add(Chip(
      key: ValueKey<Labels>(item),
      backgroundColor: ColorUtil.str2Color(item?.color),
      label: Text(item.name),
    ));

    if (!TextUtil.isEmpty(item.description)) {
      _list.add(
        Text(
          item.description,
          style: YZConstant.smallSubText,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Column(
              children: _list,
            ),
          ),
        ),
        Switch(
          value: isSelectItem(context, item),
          activeColor: Color(YZColors.mainTextColor),
          onChanged: (isSelected) {
            LogUtil.v(isSelected);
            LabelBloc bloc = BlocProvider.of<LabelBloc>(context);
            if (isSelected) {
              bloc.addIssueLabel(item);
            } else {
              bloc.deleteIssueLabel(item.name);
            }
          },
        ),
      ],
    );
  }

  bool isSelectItem(BuildContext context, Labels item) {
    LabelBloc bloc = BlocProvider.of<LabelBloc>(context);
    List<Labels> labels = bloc.labels;
    if (labels == null || labels.isEmpty || item == null) {
      return false;
    }

    for (int i = 0; i < labels.length; i++) {
      Labels label = labels[i];
      if (TextUtil.equals(item.name, label.name)) {
        return true;
      }
    }

    return false;
  }

  void _editLabel(BuildContext context, Labels label) async {
    LabelBloc bloc = BlocProvider.of<LabelBloc>(context);
    Labels result = await NavigatorUtil.goEditLabel(context, label, bloc.repo);
    if (label == null) {
      bloc.createLabel(result);
    } else {
      bloc.updateLabel(result);
    }
  }
}
