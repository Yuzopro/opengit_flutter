import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/label_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/manager/issue_manager.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/util/common_util.dart';

class EditLabelPage extends StatefulWidget {
  final Labels item;
  final String repo;

  const EditLabelPage({Key key, this.item, this.repo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditLabelState();
  }
}

class _EditLabelState extends State<EditLabelPage> {
  TextEditingController _nameController;
  TextEditingController _descController;

  bool _isCreate = true;

  bool _isLoading = false;

  Color _currentColor = Colors.amber;

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      _isCreate = false;
      if (!TextUtil.isEmpty(widget.item.color)) {
        _currentColor = ColorUtil.str2Color(widget.item.color);
      }
    }

    String name = widget.item?.name;
    String desc = widget.item?.description;
    _nameController =
        TextEditingController.fromValue(TextEditingValue(text: name ?? ''));
    _descController =
        TextEditingController.fromValue(TextEditingValue(text: desc ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonUtil.getAppBar(_isCreate ? '创建标签' : '编辑标签',
          actions: _getAction(context)),
      body: Stack(
        children: <Widget>[
          _buildBody(context),
          CommonUtil.getLoading(context, _isLoading),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _editOrCreateLabel();
        },
        backgroundColor: Colors.black,
        tooltip: 'edit label',
        child: Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final form = ListView(
      children: <Widget>[
        SizedBox(
          height: 8.0,
        ),
        _buildNameWidget(),
        SizedBox(
          height: 8.0,
        ),
        _buildDescWidget(),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: form,
    );
  }

  Widget _buildNameWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: _nameController,
            autofocus: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '名称*',
            ),
            maxLines: 1,
          ),
        ),
        InkWell(
          child: Container(
            margin: EdgeInsets.all(12.0),
            width: 48,
            height: 48,
            color: _currentColor,
          ),
          onTap: () {
            // showDialog(
            //   context: context,
            //   builder: (BuildContext context) {
            //     return AlertDialog(
            //       title: Text('Select a color'),
            //       content: SingleChildScrollView(
            //         child: ColorPicker(
            //           pickerColor: Colors.amber,
            //           onColorChanged: changeColor,
            //         ),
            //       ),
            //     );
            //   },
            // );
          },
        ),
      ],
    );
  }

  Widget _buildDescWidget() {
    return TextFormField(
      controller: _descController,
      autofocus: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: '描述',
      ),
      maxLines: 5,
    );
  }

  List<Widget> _getAction(BuildContext context) {
    if (widget.item == null) {
      return null;
    }
    return [
      InkWell(
        child: Container(
          width: 56,
          height: 56,
          child: Icon(Icons.delete),
        ),
        onTap: () {
          _deleteLabel();
        },
      )
    ];
  }

  void changeColor(Color color) => setState(() => _currentColor = color);

  _editOrCreateLabel() async {
    String name = _nameController.text.toString();
    if (TextUtil.isEmpty(name)) {
      ToastUtil.showMessgae('名称不能为空');
      return;
    }

    String desc = _descController.text.toString() ?? '';

    UserBean userBean = LoginManager.instance.getUserBean();
    String owner = userBean?.login;

    String color = ColorUtil.color2RGB(_currentColor);

    _showLoading();

    var response;
    if (_isCreate) {
      response = await IssueManager.instance
          .createLabel(owner, widget.repo, name, color, desc);
    } else {
      response = await IssueManager.instance
          .updateLabel(owner, widget.repo, widget.item.name, name, color, desc);
    }
    if (response != null && response.result) {
      Labels labels = Labels(widget.item?.id, widget.item?.nodeId,
          widget.item?.url, name, desc, color, widget.item?.default_);
      Navigator.pop(context, labels);
    } else {
      ToastUtil.showMessgae('操作失败，请重试');
    }
    _hideLoading();
  }

  void _deleteLabel() async {
    UserBean userBean = LoginManager.instance.getUserBean();
    String owner = userBean?.login;

    _showLoading();

    var response = await IssueManager.instance
        .deleteLabel(owner, widget.repo, widget.item.name);
    if (response != null && response.result) {
      widget.item.id = -1;
      Navigator.pop(context, widget.item);
    } else {
      ToastUtil.showMessgae('操作失败，请重试');
    }

    _hideLoading();
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
