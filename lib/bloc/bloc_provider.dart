import 'package:flutter/material.dart';
import 'package:open_git/bloc/base_bloc.dart';
import 'package:open_git/util/log_util.dart';

class BlocProvider<T extends BaseBloc> extends StatefulWidget {
  final T bloc;
  final Widget child;

  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  @override
  _BlocProviderState<T> createState() {
    return _BlocProviderState<T>();
  }

  static T of<T extends BaseBloc>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BaseBloc>> {
  static final String TAG = "_BlocProviderState";

  @override
  void initState() {
    super.initState();
    LogUtil.v('initState ' + T.toString(), tag: TAG);
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.v('build ' + T.toString(), tag: TAG);
    return widget.child;
  }

  @override
  void dispose() {
    super.dispose();
    LogUtil.v('dispose ' + T.toString(), tag: TAG);
    widget.bloc.dispose();
  }
}
