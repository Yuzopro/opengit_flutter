import 'package:flutter/material.dart';

class SharePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SharePageState();
  }
}

class _SharePageState extends State<SharePage> {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: _allPages.length,
      child: new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                child: new SliverAppBar(
                  title: const Text('Tabs and scrolling'),
                  pinned: true,
                  expandedHeight: 150.0,
                  forceElevated: innerBoxIsScrolled,
                  bottom: new TabBar(
                    tabs: _allPages.keys
                        .map(
                          (_Page page) => new Tab(text: page.label),
                        )
                        .toList(),
                  ),
                ),
              ),
            ];
          },
          body: new TabBarView(
            children: _allPages.keys.map((_Page page) {
              return new SafeArea(
                top: false,
                bottom: false,
                child: new Builder(
                  builder: (BuildContext context) {
                    return new CustomScrollView(
//                      key: new PageStorageKey<_Page>(page),
                      physics: AlwaysScrollableScrollPhysics(),
                      slivers: <Widget>[
                        new SliverOverlapInjector(
                          handle: NestedScrollView
                              .sliverOverlapAbsorberHandleFor(context),
                        ),
                        new SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          sliver: new SliverFixedExtentList(
                            itemExtent: _CardDataItem.height,
                            delegate: new SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final _CardData data = _allPages[page][index];
                                return new Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: new _CardDataItem(
                                    page: page,
                                    data: data,
                                  ),
                                );
                              },
                              childCount: _allPages[page].length,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _Page {
  _Page({this.label});

  final String label;

  String get id => label[0];

  @override
  String toString() => '$runtimeType("$label")';
}

class _CardData {
  const _CardData({this.title});

  final String title;
}

final Map<_Page, List<_CardData>> _allPages = <_Page, List<_CardData>>{
  new _Page(label: 'HOME'): <_CardData>[
    const _CardData(
      title: 'Flatwear',
    ),
    const _CardData(
      title: 'Pine Table',
    ),
    const _CardData(
      title: 'Blue Cup',
    ),
    const _CardData(
      title: 'Tea Set',
    ),
    const _CardData(
      title: 'Desk Set',
    ),
    const _CardData(
      title: 'Blue Linen Napkins',
    ),
    const _CardData(
      title: 'Planters',
    ),
    const _CardData(
      title: 'Kitchen Quattro',
    ),
    const _CardData(
      title: 'Platter',
    ),
  ],
  new _Page(label: 'APPAREL'): <_CardData>[
    const _CardData(
      title: 'Cloud-White Dress',
    ),
    const _CardData(
      title: 'Ginger Scarf',
    ),
    const _CardData(
      title: 'Blush Sweats',
    ),
  ],
};

class _CardDataItem extends StatelessWidget {
  const _CardDataItem({this.page, this.data});

  static const double height = 272.0;
  final _Page page;
  final _CardData data;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Align(
              alignment:
                  page.id == 'H' ? Alignment.centerLeft : Alignment.centerRight,
              child: new CircleAvatar(child: new Text('${page.id}')),
            ),
            new SizedBox(
              width: 144.0,
              height: 144.0,
            ),
            new Center(
              child: new Text(
                data.title,
                style: Theme.of(context).textTheme.title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
