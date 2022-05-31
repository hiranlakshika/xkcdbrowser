import 'package:get_it/get_it.dart';
import 'package:xkcdbrowser/blocs/comic_bloc.dart';

import '../models/comic.dart';
import '../resources/comic_api_provider.dart';

class ComicRepository {
  final ComicApiProvider _apiProvider = GetIt.I<ComicApiProvider>();

  Future<Comic?> fetchCurrentComic() async => await _apiProvider.fetchCurrentComic();

  Future<Comic?> changeComic(ComicChangeMode changeMode) async => await _apiProvider.changeComic(changeMode);
}
