import 'package:flutter/material.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/manager/issue_manager.dart';
import 'package:open_git/util/common_util.dart';

class EditIssuePage extends StatefulWidget {
  final IssueBean issueBean;

  const EditIssuePage({Key key, this.issueBean}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditIssueState();
  }
}

class _EditIssueState extends State<EditIssuePage> {
  TextEditingController _titleController;
  TextEditingController _bodyController;

  bool _isEnable = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController.fromValue(
        TextEditingValue(text: widget.issueBean.title));
    _bodyController = TextEditingController.fromValue(
        TextEditingValue(text: widget.issueBean.body));

    _titleController.addListener(() {
      if (_titleController.text.toString() == widget.issueBean.title) {
        _isEnable = false;
      } else {
        _isEnable = true;
      }
      setState(() {});
    });

    _bodyController.addListener(() {
      if (_bodyController.text.toString() == widget.issueBean.body) {
        _isEnable = false;
      } else {
        _isEnable = true;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonUtil.getAppBar(
          AppLocalizations.of(context).currentlocal.edit_issue,
          actions: getActions()),
      body: Stack(
        children: <Widget>[
          _buildBody(context),
          CommonUtil.getLoading(context, _isLoading),
        ],
      ),
    );
  }

  List<Widget> getActions() {
    Widget saveWidget = FlatButton(
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

  Widget _buildBody(BuildContext context) {
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
    _showLoading();
    final result = await IssueManager.instance.editIssue(
        widget.issueBean.repoUrl,
        widget.issueBean.number,
        _titleController.text.toString(),
        _bodyController.text.toString());
    _hideLoading();
    if (result != null) {
      Navigator.pop(context, result);
    }
  }

  _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }
}
