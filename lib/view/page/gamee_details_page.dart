import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cognixus_task/controller/provider/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';

class GameDetailsPage extends StatefulWidget {
  GameDetailsPage({super.key, this.gameTitle, this.screenshot, this.gameId});
  String? gameTitle;
  String? gameId;
  List? screenshot;

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController nestedScrollController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);

    debugPrint('short ss: ${widget.screenshot}');
    Provider.of<GameProvider>(context, listen: false).getGameDetails(gameId: widget.gameId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, notifier, child) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text("${widget.gameTitle}"),
          ),
          body: Consumer<GameProvider>(builder: (context, notifier, child) {
            if (notifier.isFetchingGameDetails == true) {
              return Container();
            } else {
              return NestedScrollView(
                  headerSliverBuilder: (context, value) {
                    return [
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        sliver: SliverSafeArea(
                          top: false,
                          bottom: false,
                          sliver: MultiSliver(
                            children: [
                              if (widget.screenshot != null && widget.screenshot!.isNotEmpty)
                                SliverPinnedHeader(
                                    child: CarouselSlider.builder(
                                  itemCount: widget.screenshot!.length,
                                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => Container(
                                    child: CachedNetworkImage(imageUrl: widget.screenshot![itemIndex]['image']),
                                  ),
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    enlargeCenterPage: false,
                                    viewportFraction: 0.9,
                                    aspectRatio: 2.0,
                                    initialPage: 0,
                                  ),
                                )),
                              SliverPinnedHeader(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                  child: TabBar(
                                    controller: _tabController,
                                    labelColor: Colors.green,
                                    isScrollable: true,
                                    indicatorColor: Colors.transparent,
                                    unselectedLabelColor: Colors.grey,
                                    unselectedLabelStyle: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    labelStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    tabs: const <Widget>[
                                      Text('Description'),
                                      Text('Platforms'),
                                      Text('Genres'),
                                      Text('Developers'),
                                      Text('Publishers'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ];
                  },
                  body: TabBarView(controller: _tabController, children: [
                    Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            detailsTitle(title: "Description"),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Html(
                              data: notifier.getGameDetailsFull['description'],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (notifier.getGameDetailsFull['platforms'].isNotEmpty) detailsTitle(title: "Available also in"),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            otherPlatformList(otherPlatform: notifier.getGameDetailsFull['platforms']),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Column(children: [
                        if (notifier.getGameDetailsFull['genres'].isNotEmpty) detailsTitle(title: "Genres"),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        genreList(genres: notifier.getGameDetailsFull['genres'])
                      ]),
                    ),
                    Container(
                      child: SingleChildScrollView(
                          child: Column(children: [
                        if (notifier.getGameDetailsFull['developers'].isNotEmpty) detailsTitle(title: "Developers"),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        developers(developers: notifier.getGameDetailsFull['developers'])
                      ])),
                    ),
                    Container(
                      child: SingleChildScrollView(
                          child: Column(children: [
                        if (notifier.getGameDetailsFull['publishers'].isNotEmpty) detailsTitle(title: "Publisher"),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        publishers(publishers: notifier.getGameDetailsFull['publishers'])
                      ])),
                    ),
                  ]));
            }
          }));
    });
  }

  Widget detailsTitle({required String title}) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget otherPlatformList({required List otherPlatform}) {
    if (otherPlatform.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: otherPlatform.length,
            itemBuilder: (context, idx) {
              return Column(
                children: [
                  CachedNetworkImage(imageUrl: otherPlatform[idx]['platform']['image_background']),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(otherPlatform[idx]['platform']['name']),
                  if (idx != (otherPlatform.length - 1))
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    )
                ],
              );
            }),
      );
    } else {
      return Container();
    }
  }

  Widget genreList({required List genres}) {
    if (genres.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: genres.length,
            itemBuilder: (context, idx) {
              return Text(genres[idx]['name']);
            }),
      );
    } else {
      return Container();
    }
  }

  Widget developers({required List developers}) {
    if (developers.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: developers.length,
            itemBuilder: (context, idx) {
              return Column(
                children: [
                  CachedNetworkImage(imageUrl: developers[idx]['image_background']),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(developers[idx]['name']),
                  if ((idx != developers.length - 1))
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    )
                ],
              );
            }),
      );
    } else {
      return Container();
    }
  }

  Widget publishers({required List publishers}) {
    if (publishers.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: publishers.length,
            itemBuilder: (context, idx) {
              return Column(
                children: [
                  CachedNetworkImage(imageUrl: publishers[idx]['image_background']),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(publishers[idx]['name']),
                  if ((idx != publishers.length - 1))
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    )
                ],
              );
            }),
      );
    } else {
      return Container();
    }
  }
}
