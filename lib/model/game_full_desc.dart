class GameFullDesc {
  late String name;
  late String releaseDate;
  late String backgroundImg;
  late String metacriticScore;
  late String description;
  late List otherPlatform;
  late List genres;
  late List developers;
  late List publishers;

  GameFullDesc();

  GameFullDesc.fromMap(Map<String, dynamic> data) {
    name = data['name'];
    releaseDate = data['released'];
    backgroundImg = data['background_image'];
    metacriticScore = data['metacritic'];
    description = data['description'];
    otherPlatform = data['platforms'];
    genres = data['genres'];
    developers = data['developers'];
    publishers = data['publishers'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'releaseDate': releaseDate,
      'backgroundImg': backgroundImg,
      'metatriticScore': metacriticScore,
      'description': description,
      'otherPlatform': otherPlatform,
      'genres': genres,
      'developers': developers,
      'publishers': publishers,
    };
  }
}
