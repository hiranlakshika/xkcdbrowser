import 'package:get_it/get_it.dart';

import '../models/comic.dart';
import '../resources/comic_api_provider.dart';

class ComicRepository {
  final ComicApiProvider _apiProvider = GetIt.I<ComicApiProvider>();

  Future<Comic?> fetchCurrentComic() async => await _apiProvider.fetchCurrentComic();

  Future<Comic?> getComicByNumber(int number) async => await _apiProvider.getComicByNumber(number);
}
