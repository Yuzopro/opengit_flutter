import 'package:flutter/material.dart';
import 'package:open_git/bloc/base_bloc.dart';
import 'package:open_git/bloc/bloc_provider.dart';

abstract class BaseStatelessWidget<B extends BaseBloc> extends StatelessWidget {
  B bloc;

  Widget buildWidget(BuildContext context);

  String getTitle(BuildContext context) {
    return "";
  }

  bool isShowAppBar() {
    return true;
  }

  void initData() {
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<B>(context);

    initData();

    return new Scaffold(
      appBar: isShowAppBar()
          ? new AppBar(
              elevation: 0,
              title: new Text(getTitle(context)),
            )
          : null,
      body: buildWidget(context),
    );
  }
}
