import "package:flutter/material.dart";
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/org_bean.dart';
import 'package:open_git/bloc/org_profile_bloc.dart';
import 'package:open_git/common/gradient_const.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/size_util.dart';

const items = [
  '项目',
  '动态',
  '成员',
];

const SQUARE_BUTTON_HEIGHT = 127.0;
const PHOTO_BUTTON_HEIGHT = 200.0;
const REC_BUTTON_WIDTH = 255.0;
const REC_BUTTON_HEIGHT = 96.0;
const TOP_BAR_HEIGHT = 152.0;
const TOP_BAR_GRADIENT_HEIGHT = 133.0;
const BOTTOM_BAR_HEIGHT = 200.0;

class OrgProfilePage
    extends BaseStatelessWidget<LoadingBean<OrgBean>, OrgProfileBloc> {
  @override
  PageType getPageType() => PageType.org_profile;

  @override
  String getTitle(BuildContext context) {
    OrgProfileBloc bloc = BlocProvider.of<OrgProfileBloc>(context);
    return bloc.org;
  }

  @override
  bool isShowAppBarActions() => true;

  @override
  int getItemCount(LoadingBean<OrgBean> data) => 1;

  @override
  bool isLoading(LoadingBean<OrgBean> data) =>
      data != null ? data.isLoading : true;

  @override
  void openWebView(BuildContext context) {
    OrgProfileBloc bloc = BlocProvider.of<OrgProfileBloc>(context);
    NavigatorUtil.goWebView(context, bloc.org, bloc.bean.data.htmlUrl);
  }

  @override
  String getShareText(BuildContext context) {
    OrgProfileBloc bloc = BlocProvider.of<OrgProfileBloc>(context);
    return bloc.bean.data.htmlUrl;
  }

  @override
  Widget getChild(BuildContext context, LoadingBean<OrgBean> bean) {
    if (bean == null || bean.data == null) {
      return Container();
    }

    OrgProfileBloc bloc = BlocProvider.of<OrgProfileBloc>(context);
    String name = bloc.org;

    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: 100,
                    top: 30,
                    right: 15,
                    bottom: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ImageUtil.getCircleNetworkImage(
                          bean.data.avatarUrl,
                          SizeUtil.getAxisY(SQUARE_BUTTON_HEIGHT),
                          ImagePath.image_default_head),
                      SizedBox(height: 20.0),
                      Text(
                        bean.data.name ?? bean.data.login,
                        style: YZConstant.largeLargeText,
                      ),
                      Text(
                        bean.data.description ?? '暂无描述',
                        style: YZConstant.largeText,
                      ),
                    ],
                  ),
                ),
                _buildItems(bean.data, name),
                Container(
                  padding: EdgeInsets.only(
                      left: 100, top: 30, right: 15, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      LabelIcon(
                        label: bean.data.company ?? '暂未设置公司',
                        image: ImagePath.image_profile_company,
                      ),
                      LabelIcon(
                        label: bean.data.location ?? '暂未设置地址',
                        image: ImagePath.image_profile_location,
                      ),
                      LabelIcon(
                        label: bean.data.email ?? '暂未设置邮箱',
                        image: ImagePath.image_profile_email,
                      ),
                      LabelIcon(
                        label: bean.data.blog ?? '暂未设置博客',
                        image: ImagePath.image_profile_blog_small,
                        onPressed: bean.data.blog ??
                            () {
                              NavigatorUtil.goWebView(
                                  context, '博客', bean.data.blog);
                            },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemText({String txt, String num, GestureTapCallback onTap}) {
    List<Widget> children = [];
    if (!TextUtil.isEmpty(num)) {
      children.add(Text(
        num,
        style: YZConstant.normalTextWhite,
      ));
    }
    children.add(Text(
      txt,
      style: YZConstant.middleTextWhite,
    ));

    return InkWell(
      child: Container(
        margin: EdgeInsets.only(
          left: SizeUtil.getAxisX(10.0),
          right: SizeUtil.getAxisX(10.0),
        ),
        constraints: BoxConstraints.expand(
          height: SizeUtil.getAxisY(PHOTO_BUTTON_HEIGHT),
          width: SizeUtil.getAxisX(PHOTO_BUTTON_HEIGHT),
        ),
        decoration: BoxDecoration(
          gradient: BUTTON_BACKGROUND,
          borderRadius: BorderRadius.circular(22.0),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildItems(OrgBean bean, String name) {
    return Container(
      constraints:
          BoxConstraints.expand(height: SizeUtil.getAxisY(PHOTO_BUTTON_HEIGHT)),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, idx) {
          String num = '';
          GestureTapCallback callback;
          if (idx == 0) {
            num = bean.publicRepos.toString();
            callback = () {
              NavigatorUtil.goOrgRepos(context, name);
            };
          } else if (idx == 1) {
            callback = () {
              NavigatorUtil.goOrgEvent(context, name);
            };
          } else if (idx == 2) {
            callback = () {
              NavigatorUtil.goOrgMember(context, name);
            };
          }
          return _itemText(txt: items[idx], num: num, onTap: callback);
        },
      ),
    );
  }
}
