import 'package:cached_network_image/cached_network_image.dart';
import 'package:cognixus_task/controller/provider/game_provider.dart';
import 'package:cognixus_task/view/page/gamee_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';

class GameListPage extends StatefulWidget {
  const GameListPage({super.key});

  @override
  State<GameListPage> createState() => _GameListPageState();
}

class _GameListPageState extends State<GameListPage> {
  int currentPage = 1;

  @override
  void initState() {
    Provider.of<GameProvider>(context, listen: false).getGameList(page: currentPage.toString(), dateRange: '2020-05-18,2021-05-18');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, notifier, child) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("Playstation 5 Game List"),
          ),
          body: Consumer<GameProvider>(builder: (context, notifier, child) {
            if (notifier.isFetchingGameList == false && notifier.gameList.isEmpty) {
              return Container();
            } else {
              return Center(
                child: LazyLoadScrollView(
                    onEndOfPage: () async {
                      if (notifier.isFetchingGameList == false) {
                        var res = await Provider.of<GameProvider>(context, listen: false).getGameList(page: currentPage.toString(), dateRange: '2020-05-18,2021-05-18');
                        if (res != null && res.isNotEmpty) {
                          currentPage++;
                        }
                      }
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: notifier.getGameListShordDesc.length,
                              itemBuilder: (context, idx) {
                                return Center(
                                    child: GestureDetector(
                                  onTap: () {
                                    Navigator.push<void>(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) => GameDetailsPage(gameTitle: notifier.getGameListShordDesc[idx]['name'], screenshot: notifier.getGameListShordDesc[idx]['short_screenshots'], gameId: notifier.getGameListShordDesc[idx]['id'].toString()),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(child: CachedNetworkImage(imageUrl: notifier.getGameListShordDesc[idx]['background_image'])),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.02,
                                      ),
                                      details(field: "Title : ", value: notifier.getGameListShordDesc[idx]['name']),
                                      details(
                                        field: "Date Released : ",
                                        value: notifier.getGameListShordDesc[idx]['released'],
                                      ),
                                      if (notifier.getGameListShordDesc[idx]['metacritic'] != null && notifier.getGameListShordDesc[idx]['metacritic'] != "") details(field: "Metacritic : ", value: notifier.getGameListShordDesc[idx]['metacritic'].toString()),
                                      if (idx != (notifier.getGameListShordDesc.length - 1))
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.03,
                                        ),
                                    ],
                                  ),
                                ));
                              }),
                          if (notifier.isFetchingGameList == true)
                            Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.03,
                                ),
                                const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.03,
                                ),
                              ],
                            )
                        ],
                      ),
                    )),
              );
            }
          }));
    });
  }

  Widget details({required field, required String value}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(field), Flexible(child: Text(value))],
      ),
    );
  }
}
