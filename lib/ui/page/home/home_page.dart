import 'package:flukit/flukit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_stateless_widget.dart';
import 'package:flutter_base_ui/bloc/loading_bean.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/home_banner_bean.dart';
import 'package:open_git/bean/home_bean.dart';
import 'package:open_git/bean/home_item_bean.dart';
import 'package:open_git/bloc/home_bloc.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/ui/widget/header_item.dart';
import 'package:open_git/ui/widget/home_item_widget.dart';

class HomePage extends BaseStatelessWidget<LoadingBean<HomeBean>, HomeBloc> {
  @override
  bool isShowAppBar(BuildContext context) => false;

  @override
  int getItemCount(LoadingBean<HomeBean> data) => 1;

  @override
  bool isLoading(LoadingBean<HomeBean> data) {
    return data != null ? data.isLoading : true;
  }

  @override
  Widget getChild(BuildContext context, LoadingBean<HomeBean> bean) {
    if (bean == null ||
        bean.data == null ||
        bean.data.banner == null ||
        bean.data.itemBean == null) {
      return Container();
    }

    return ListView(
      children: <Widget>[
        _buildBanner(context, bean.data.banner),
        _buildItem(context, bean.data.itemBean.recommend, Icons.book, "推荐项目"),
        _buildItem(context, bean.data.itemBean.other, Icons.language, "其他资源"),
      ],
    );
  }

  Widget _buildBanner(BuildContext context, List<Data> list) {
    return new AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: Swiper(
        indicatorAlignment: AlignmentDirectional.topEnd,
        circular: true,
        interval: const Duration(seconds: 5),
        indicator: NumberSwiperIndicator(),
        children: list.map((model) {
          return new InkWell(
            onTap: () {
              NavigatorUtil.goWebView(context, model.title, model.url);
            },
            child: ImageUtil.getNetworkImage(model.imagePath),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItem(BuildContext context, List<HomeItem> list,
      IconData leftIcon, String title) {
    List<Widget> _children = list.map((model) {
      return HomeItemWidget(model);
    }).toList();
    List<Widget> children = new List();
    children.add(HeaderItem(
      leftIcon: leftIcon,
      title: title,
    ));
    children.addAll(_children);
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class NumberSwiperIndicator extends SwiperIndicator {
  @override
  Widget build(BuildContext context, int index, int itemCount) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black45, borderRadius: BorderRadius.circular(20.0)),
      margin: EdgeInsets.only(top: 10.0, right: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      child: Text("${++index}/$itemCount",
          style: TextStyle(color: Colors.white70, fontSize: 11.0)),
    );
  }
}
