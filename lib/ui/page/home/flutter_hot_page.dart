import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_stateless_widget.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/bloc/flutter_hot_bloc.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/ui/widget/flutter_hot_item_widget.dart';

class FlutterHotPage
    extends BaseListStatelessWidget<Entrylist, FlutterHotBloc> {
  static final String TAG = "HomePage";

  @override
  String getTitle(BuildContext context) => "掘金Flutter社区";

  @override
  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _showAlertDialog(context);
      },
      child: Text(
        AppLocalizations.of(context).currentlocal.disclaimer_,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget builderItem(BuildContext context, Entrylist item) {
    return FlutterHotItemWidget(item);
  }

  void _showAlertDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).currentlocal.disclaimer,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(Config.disclaimerText1),
                Text(Config.disclaimerText2),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), // 圆角

          actions: <Widget>[
            Container(
              width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context).currentlocal.got_it,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
