import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xkcdbrowser/blocs/bloc_holder.dart';

import '../models/comic.dart';
import '../repository/comic_repository.dart';

class ComicBloc extends BlocBase {
  /* Repositories */
  final ComicRepository _comicRepository = GetIt.I<ComicRepository>();

  /* Rxdart objects */
  final _currentComicSubject = BehaviorSubject<Comic?>();

  /* Streams */
  Stream<Comic?> get currentComicStream => _currentComicSubject.stream;

  @override
  void dispose() {
    _currentComicSubject.close();
  }

  fetchCurrentComic() async {
    var comic = await _comicRepository.fetchCurrentComic();
    _currentComicSubject.sink.add(comic);
  }
}
