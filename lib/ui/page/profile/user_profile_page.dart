import "package:flutter/material.dart";
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/bloc/profile_bloc.dart';
import 'package:open_git/common/gradient_const.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/common/url_const.dart';
import 'package:open_git/manager/user_manager.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/size_util.dart';

const items = [
  '项目',
  'star项目',
  '我关注的',
  '关注我的',
  '动态',
  '组织',
];

const SQUARE_BUTTON_HEIGHT = 127.0;
const PHOTO_BUTTON_HEIGHT = 200.0;
const REC_BUTTON_WIDTH = 255.0;
const REC_BUTTON_HEIGHT = 96.0;
const TOP_BAR_HEIGHT = 152.0;
const TOP_BAR_GRADIENT_HEIGHT = 133.0;
const BOTTOM_BAR_HEIGHT = 200.0;

class UserProfilePage
    extends BaseStatelessWidget<LoadingBean<UserBean>, ProfileBloc> {

  @override
  String getTitle(BuildContext context) {
    ProfileBloc bloc = BlocProvider.of<ProfileBloc>(context);
    return bloc.name;
  }

  @override
  bool isShowAppBarActions() => true;

  @override
  int getItemCount(LoadingBean<UserBean> data) => 1;

  @override
  bool isLoading(LoadingBean<UserBean> data) =>
      data != null ? data.isLoading : true;

  @override
  void openWebView(BuildContext context) {
    ProfileBloc bloc = BlocProvider.of<ProfileBloc>(context);
    NavigatorUtil.goWebView(context, bloc.name, bloc.bean.data.html_url);
  }

  @override
  String getShareText(BuildContext context) {
    ProfileBloc bloc = BlocProvider.of<ProfileBloc>(context);
    return bloc.bean.data.html_url;
  }

  @override
  Widget getChild(BuildContext context, LoadingBean<UserBean> bean) {
    if (bean == null || bean.data == null) {
      return Container();
    }

    ProfileBloc bloc = BlocProvider.of<ProfileBloc>(context);
    String name = bloc.name;

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _profileRow(context, bean.data),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        bean.data.name ?? bean.data.login,
                        style: YZStyle.largeLargeText,
                      ),
                      Text(
                        bean.data.bio ?? '暂无简介',
                        style: YZStyle.largeText,
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
                                  context, 'Yuzo Blog', bean.data.blog);
                            },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _bottomBar(context, name),
        ],
      ),
    );
  }

  List<Widget> _profileRow(BuildContext context, UserBean bean) {
    List<Widget> children = [];
    children.add(ImageUtil.getCircleNetworkImage(bean.avatar_url,
        SizeUtil.getAxisY(SQUARE_BUTTON_HEIGHT), ImagePath.image_default_head));

    if (bean.isFollow != null && !UserManager.instance.isYou(bean.login)) {
      children.add(_buildFollow(context, bean));
    }
    return children;
  }

  Widget _buildFollow(BuildContext context, UserBean bean) {
    return Container(
      width: SizeUtil.getAxisY(REC_BUTTON_WIDTH),
      height: SizeUtil.getAxisY(REC_BUTTON_HEIGHT),
      decoration: BoxDecoration(
        gradient: BUTTON_BACKGROUND,
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: InkWell(
          onTap: () {
            ProfileBloc bloc = BlocProvider.of<ProfileBloc>(context);
            bloc.followOrUnFollow();
          },
          splashColor: Colors.grey,
          highlightColor: Colors.grey,
          borderRadius: BorderRadius.circular(100.0),
          child: Center(
            child: Text(
              bean.isFollow ? '取消关注' : '关注',
              style: YZStyle.largeTextWhite,
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemText({String txt, String num, GestureTapCallback onTap}) {
    List<Widget> children = [];
    if (!TextUtil.isEmpty(num)) {
      children.add(Text(
        num,
        style: YZStyle.normalTextWhite,
      ));
    }
    children.add(Text(
      txt,
      style: YZStyle.middleTextWhite,
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

  Widget _buildItems(UserBean bean, String name) {
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
            num = bean.public_repos.toString();
            callback = () {
              NavigatorUtil.goProfileRepos(context, name);
            };
          } else if (idx == 1) {
            callback = () {
              NavigatorUtil.goProfileStarRepos(context, name);
            };
          } else if (idx == 2) {
            num = bean.following.toString();
            callback = () {
              NavigatorUtil.goProfileFollowing(context, name);
            };
          } else if (idx == 3) {
            num = bean.followers.toString();
            callback = () {
              NavigatorUtil.goProfileFollower(context, name);
            };
          } else if (idx == 4) {
            callback = () {
              NavigatorUtil.goProfileEvent(context, name);
            };
          } else if (idx == 5) {
            callback = () {
              NavigatorUtil.goProfileOrg(context, name);
            };
          }
          return _itemText(txt: items[idx], num: num, onTap: callback);
        },
      ),
    );
  }

  Widget _bottomBar(BuildContext context, name) {
    if (TextUtil.equals('Yuzopro', name)) {
      return Row(
        children: <Widget>[
          _bottomItemBar(
              text: '博客',
              image: ImagePath.image_profile_blog,
              onTap: () {
                NavigatorUtil.goWebView(context, 'Yuzo Blog', BLOG);
              }),
          _bottomItemBar(
              text: '掘金',
              image: ImagePath.image_profile_juejin,
              onTap: () {
                NavigatorUtil.goWebView(context, '掘金', JUEJIN);
              }),
          _bottomItemBar(
              text: '简书',
              image: ImagePath.image_profile_jianshu,
              onTap: () {
                NavigatorUtil.goWebView(context, '简书', JIANSHU);
              }),
          _bottomItemBar(
              text: 'CSDN',
              image: ImagePath.image_profile_csdn,
              onTap: () {
                NavigatorUtil.goWebView(context, 'CSDN', CSDN);
              }),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _bottomItemBar({String text, String image, GestureTapCallback onTap}) {
    return Expanded(
      child: InkWell(
        child: Container(
          alignment: Alignment.center,
          width: SizeUtil.getAxisX(PHOTO_BUTTON_HEIGHT),
          height: SizeUtil.getAxisY(PHOTO_BUTTON_HEIGHT),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: YZStyle.normalText,
              ),
              SizedBox(
                height: 8.0,
              ),
              ImageUtil.getImage(image, YZSize.BIG_IMAGE_SIZE, YZSize.BIG_IMAGE_SIZE)
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
