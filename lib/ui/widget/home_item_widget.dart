import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/home_item_bean.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/route/navigator_util.dart';

class HomeItemWidget extends StatelessWidget {
  final HomeItem model;

  const HomeItemWidget(
    this.model, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (model.type == 1) {
          NavigatorUtil.goReposDetail(context, model.name, model.repo);
        } else if (model.type == 2) {
          NavigatorUtil.goWebView(context, model.title, model.url);
        } else if (model.type == 3) {
          NavigatorUtil.goFlutterHot(context);
        } else if (model.type == 4) {
          NavigatorUtil.goUserProfile(context, model.name, "", "");
        }
      },
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(),
            Row(
              children: <Widget>[
                _buildLeft(),
                _buildRight(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeft() => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                model.title ?? '--',
                style: YZStyle.middleTextBold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                TextUtil.isEmpty(model.subTitle) ? '暂无描述' : model.subTitle,
                style: YZStyle.smallTextT65,
              ),
            ),
            _actionColumn(),
          ],
        ),
      );

  Widget _buildRight() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ImageUtil.getNetworkImageBySize(
            model.image, 64, ImagePath.image_default_head),
      );

  Widget _actionColumn() => ButtonBar(
        alignment: MainAxisAlignment.start,
        children: <Widget>[
          LabelIcon(
            label: model.tag,
            image: ImagePath.image_issue_label,
          ),
        ],
      );
}
