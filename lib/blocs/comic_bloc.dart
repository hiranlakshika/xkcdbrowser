import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xkcdbrowser/blocs/bloc_holder.dart';

import '../main.dart';
import '../models/comic.dart';
import '../objectbox.g.dart';
import '../repository/comic_repository.dart';

enum ComicChangeMode {
  next,
  previous,
}

class ComicBloc extends BlocBase {
  /* Repositories */
  final ComicRepository _comicRepository = GetIt.I<ComicRepository>();

  /* Rxdart objects */
  final _currentComicSubject = BehaviorSubject<Comic?>();
  final _savedComics = BehaviorSubject<List<Comic>>();

  /* Streams */
  Stream<Comic?> get currentComicStream => _currentComicSubject.stream;

  Stream<List<Comic>> get savedComicStream => _savedComics.stream;

  /* Local variables */
  int _currentComicNumber = 0;

  @override
  void dispose() {
    _currentComicSubject.close();
  }

  fetchCurrentComic() async {
    var comic = await _comicRepository.fetchCurrentComic();
    if (comic != null) _currentComicNumber = comic.number;
    _currentComicSubject.sink.add(comic);
  }

  changeComic(ComicChangeMode changeMode) async {
    int oldNumber = _currentComicNumber;

    changeMode == ComicChangeMode.previous ? --_currentComicNumber : ++_currentComicNumber;

    final comicBox = objectbox.store.box<Comic>();
    final query = comicBox.query(Comic_.number.equals(_currentComicNumber)).build();

    var savedComic = query.findUnique();
    query.close();

    if (savedComic != null) {
      _currentComicSubject.sink.add(savedComic);
      return;
    }

    var comic = await _comicRepository.changeComic(_currentComicNumber);
    if (comic != null) {
      _currentComicNumber = comic.number;
      _currentComicSubject.sink.add(comic);
    } else {
      _currentComicNumber = oldNumber;
    }
  }

  addToFavorite(Comic comic) {
    final comicBox = objectbox.store.box<Comic>();
    comicBox.put(comic);
  }

  retrieveSavedComics() {
    final comicBox = objectbox.store.box<Comic>();
    _savedComics.sink.add(comicBox.getAll());
  }

  removeFromFavorites(int id) {
    final comicBox = objectbox.store.box<Comic>();
    comicBox.remove(id);
    _savedComics.sink.add(comicBox.getAll());
  }
}
