import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/bloc/base_list_stateless_widget.dart';
import 'package:flutter_base_ui/bloc/page_type.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/org_bean.dart';
import 'package:open_git/bloc/org_bloc.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/route/navigator_util.dart';

class OrgPage extends BaseListStatelessWidget<OrgBean, OrgBloc> {
  @override
  PageType getPageType() {
    return PageType.profile_orgs;
  }

  @override
  String getTitle(BuildContext context) {
    return '组织';
  }

  @override
  Widget builderItem(BuildContext context, OrgBean item) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _postCard(context, item),
      ),
      onTap: () {
        NavigatorUtil.goOrgProfile(context, item.login);
      },
    );
  }

  Widget _postCard(BuildContext context, OrgBean item) {
    return Card(
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _profileColumn(context, item),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.description,
              style: YZConstant.smallTextT65,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileColumn(BuildContext context, OrgBean item) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ImageUtil.getCircleNetworkImage(
              item.avatarUrl, 36.0, ImagePath.image_default_head),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                item.login,
                style: YZConstant.smallText,
              ),
            ),
          ),
        ],
      );
}
