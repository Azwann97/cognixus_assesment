class GameShortDesc {
  late String name;
  late String releaseDate;
  late String backgroundImg;
  late String metacriticScore;

  GameShortDesc();

  GameShortDesc.fromMap(Map<String, dynamic> data) {
    name = data['name'];
    releaseDate = data['released'];
    backgroundImg = data['background_image'];
    metacriticScore = data['metacritic'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'releaseDate': releaseDate,
      'backgroundImg': backgroundImg,
      'metatriticScore': metacriticScore,
    };
  }
}
