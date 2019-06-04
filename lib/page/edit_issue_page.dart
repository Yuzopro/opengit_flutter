import 'package:flutter/material.dart';
import 'package:open_git/base/base_state.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/contract/edit_issue_contract.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/presenter/edit_issue_presenter.dart';

class EditIssuePage extends StatefulWidget {
  final IssueBean issueBean;
  final String repoUrl;

  const EditIssuePage({Key key, this.issueBean, this.repoUrl})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditIssueState(issueBean, repoUrl);
  }
}

class _EditIssueState
    extends BaseState<EditIssuePage, EditIssuePresenter, IEditIssueView>
    implements IEditIssueView {
  TextEditingController _titleController;
  TextEditingController _bodyController;

  bool _isEnable = false;

  final IssueBean issueBean;
  final String repoUrl;

  _EditIssueState(this.issueBean, this.repoUrl);

  @override
  void initData() {
    super.initData();

    _titleController = TextEditingController.fromValue(
        new TextEditingValue(text: issueBean.title));
    _bodyController = TextEditingController.fromValue(
        new TextEditingValue(text: issueBean.body));

    _titleController.addListener(() {
      if (_titleController.text.toString() == issueBean.title) {
        _isEnable = false;
      } else {
        _isEnable = true;
      }
      setState(() {});
    });

    _bodyController.addListener(() {
      if (_bodyController.text.toString() == issueBean.body) {
        _isEnable = false;
      } else {
        _isEnable = true;
      }
      setState(() {});
    });
  }

  @override
  String getTitle() {
    return AppLocalizations.of(context).currentlocal.edit_issue;
  }

  @override
  List<Widget> getActions() {
    Widget saveWidget = new FlatButton(
      onPressed: _isEnable
          ? () {
              _editIssue();
            }
          : null,
      child: Icon(Icons.check),
      disabledTextColor: Colors.grey,
      textColor: Colors.white,
    );
    return [saveWidget];
  }

  @override
  Widget buildBody(BuildContext context) {
    final form = ListView(
      children: <Widget>[
        Text(AppLocalizations.of(context).currentlocal.edit_issue_title),
        _buildTitleWidget(),
        Text(AppLocalizations.of(context).currentlocal.edit_issue_desc),
        _buildBodyWidget(),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: form,
    );
  }

  @override
  EditIssuePresenter initPresenter() {
    return new EditIssuePresenter();
  }

  Widget _buildTitleWidget() {
    return TextField(
      controller: _titleController,
      autofocus: true,
    );
  }

  Widget _buildBodyWidget() {
    return TextField(
      controller: _bodyController,
      autofocus: false,
    );
  }

  _editIssue() async {
    if (presenter != null) {
      final result = await presenter.editIssue(repoUrl, issueBean.number,
          _titleController.text.toString(), _bodyController.text.toString());
      if (result != null) {
        Navigator.pop(context, result);
      }
    }
  }

  @override
  onEditSuccess(IssueBean issueBean) {
    return null;
  }
}
