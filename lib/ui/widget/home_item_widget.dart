import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/db/read_record_provider.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';

class HomeItemWidget extends StatelessWidget {
  final Entrylist item;

  HomeItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _postCard(context, item),
      ),
      onTap: () {
        String title = item.title;
        String url = item.originalUrl;

        ReadRecordProvider().insert(
          title: title,
          url: url,
          date: DateTime.now().millisecondsSinceEpoch,
          type: ReadRecordProvider.TYPE_H5,
          data: jsonEncode(item.toJson),
        );

        NavigatorUtil.goWebView(context, item.title, item.originalUrl);
      },
    );
  }

  Widget _postCard(BuildContext context, Entrylist item) {
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              item.title ?? '--',
              style: YZStyle.middleTextBold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              TextUtil.isEmpty(item.content) ? '暂无描述' : item.content,
              style: YZStyle.smallTextT65,
            ),
          ),
          _actionColumn(item),
        ],
      ),
    );
  }

  Widget _profileColumn(BuildContext context, Entrylist item) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      ImageUtil.getCircleNetworkImage(
          item.user.avatarLarge, 36.0, ImagePath.image_default_head),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            item.user.username ?? '--',
            style: YZStyle.smallText,
          ),
        ),
      ),
      _getItemTag(item.tags),
    ],
  );

  Widget _actionColumn(Entrylist item) => ButtonBar(
    alignment: MainAxisAlignment.start,
    children: <Widget>[
      LabelIcon(
        label: item.collectionCount.toString(),
        image: ImagePath.image_like,
      ),
      LabelIcon(
        label: item.commentsCount.toString(),
        image: ImagePath.image_comment,
      ),
    ],
  );

  Widget _getItemTag(List<Tags> tags) {
    String tag = "";
    if (tags != null && tags.length > 0) {
      if (tags.length > 2) {
        tags.length = 2;
      }
      for (int i = 0; i < tags.length; i++) {
        tag += (tags[i].title + "\/");
      }
    }
    return Text(
      tag,
      style: YZStyle.smallSubText,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}