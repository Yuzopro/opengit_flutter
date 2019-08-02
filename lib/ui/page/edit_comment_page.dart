import 'package:flutter/material.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/manager/issue_manager.dart';
import 'package:open_git/util/common_util.dart';

class EditCommentPage extends StatefulWidget {
  final IssueBean issueBean;
  final String repoUrl;
  final bool isAdd;

  EditCommentPage(this.issueBean, this.repoUrl, this.isAdd);

  @override
  State<StatefulWidget> createState() {
    return _EditCommentState();
  }
}

class _EditCommentState extends State<EditCommentPage> {
  TextEditingController _controller;

  bool _isEnable = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController.fromValue(
        TextEditingValue(text: widget.isAdd ? "" : widget.issueBean.body));
    _controller.addListener(() {
      if (_controller.text.toString() ==
          (widget.isAdd ? "" : widget.issueBean.body)) {
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
      appBar: CommonUtil.getAppBar(_getTitle(), actions: _getActions()),
      body: Stack(
        children: <Widget>[
          _buildBody(context),
          CommonUtil.getLoading(context, _isLoading),
        ],
      ),
    );
  }

  String _getTitle() {
    return "编辑评论";
  }

  List<Widget> _getActions() {
    Widget saveWidget = FlatButton(
      onPressed: _isEnable
          ? () {
              _editIssueComment();
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
        SizedBox(
          height: 8.0,
        ),
        _buildEditor(),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: form,
    );
  }

  Widget _buildEditor() {
    return TextFormField(
      controller: _controller,
      autofocus: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        helperText: '支持Markdown语法',
        labelText: '评论',
      ),
      maxLines: 5,
    );
  }

  _editIssueComment() async {
    IssueBean result = null;
    _showLoading();
    if (!widget.isAdd) {
      result = await IssueManager.instance.editIssueComment(
          widget.repoUrl, widget.issueBean.id, _controller.text.toString());
    } else {
      result = await IssueManager.instance.addIssueComment(
          widget.repoUrl, widget.issueBean.number, _controller.text.toString());
    }
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
