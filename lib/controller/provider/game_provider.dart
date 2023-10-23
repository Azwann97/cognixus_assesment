import 'package:cognixus_task/API/game_deets_api.dart';
import 'package:flutter/foundation.dart';

class GameProvider extends ChangeNotifier {
  late String name;
  late String releaseDate;
  late String backgroundImg;
  late String metacriticScore;
  late String description;

  String get getName => name;
  String get getReleasedDate => releaseDate;
  String get getBackGroundImg => backgroundImg;
  String get getMetacriticScore => metacriticScore;
  String get getDescription => description;

  late List otherPlatform;
  late List genres;
  late List developers;
  late List publishers;
  late List gameList = [];

  List get getOtherPlatforms => otherPlatform;
  List get getGenres => genres;
  List get getDevelopers => developers;
  List get getPublishers => publishers;
  List get getGameListShordDesc => gameList;

  Map gameDetails = {};
  Map get getGameDetailsFull => gameDetails;

  bool fetchGameList = false;
  bool fetchGameDeets = false;

  bool get isFetchingGameList => fetchGameList;
  bool get isFetchingGameDetails => fetchGameDeets;

  getGameList({required String page, required String dateRange, bool? changeDateRange}) async {
    fetchGameList = true;
    notifyListeners();

    var res = {};
    try {
      res = await GameDeetsApi().getShortDesc(page: page, dateRange: dateRange);
    } catch (e) {
      debugPrint('error in fetching game list: $e');
    }

    debugPrint('res return : $res');

    if (page == '1' || changeDateRange == true) {
      gameList = res['results'];
    } else if (res['results'] != null) {
      if (res['results'].isNotEmpty) {
        gameList.addAll(res['results']);
      }
    }
    fetchGameList = false;
    notifyListeners();

    debugPrint('get game list api return : $gameList');
    return res['results'];
  }

  getGameDetails({required String gameId}) async {
    gameDetails = {};
    fetchGameDeets = true;
    notifyListeners();

    var res = {};
    try {
      res = await GameDeetsApi().getFullDesc(gameID: gameId);
    } catch (e) {
      debugPrint('error in fetching game details: $e');
    }

    gameDetails = res;
    fetchGameDeets = false;
    notifyListeners();

    debugPrint('get game details api return : $gameDetails');
    return res;
  }
}
