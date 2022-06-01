import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../main.dart';
import '../models/comic.dart';
import '../objectbox.g.dart';
import '../repository/comic_repository.dart';
import 'bloc_holder.dart';
import 'notification_bloc.dart';

enum ComicChangeMode {
  next,
  previous,
}

class ComicBloc extends BlocBase {
  /* Blocs */
  final NotificationBloc _notificationBloc = GetIt.I<NotificationBloc>();

  /* Repositories */
  final ComicRepository _comicRepository = GetIt.I<ComicRepository>();

  /* Rxdart objects */
  final _currentComicSubject = BehaviorSubject<Comic?>();
  final _selectedComicSubject = BehaviorSubject<Comic?>();
  final _savedComicsSubject = BehaviorSubject<List<Comic>>();

  /* Streams */
  Stream<Comic?> get currentComicStream => _currentComicSubject.stream;

  Stream<Comic?> get selectedComicStream => _selectedComicSubject.stream;

  Stream<List<Comic>> get savedComicStream => _savedComicsSubject.stream;

  /* Local variables */
  int _currentComicNumber = 0;
  int _lastComicNumber = 0;

  @override
  void dispose() {
    _currentComicSubject.close();
    _selectedComicSubject.close();
    _savedComicsSubject.close();
  }

  fetchCurrentComic() async {
    var comic = await _comicRepository.fetchCurrentComic();
    if (comic != null) {
      _currentComicNumber = comic.number;
      _lastComicNumber = comic.number;
    }
    _currentComicSubject.sink.add(comic);
  }

  changeComic(ComicChangeMode changeMode) async {
    int oldNumber = _currentComicNumber;

    changeMode == ComicChangeMode.previous ? --_currentComicNumber : ++_currentComicNumber;

    var savedComic = getSavedComic(_currentComicNumber);

    if (savedComic != null) {
      _currentComicSubject.sink.add(savedComic);
      return;
    }

    var comic = await _comicRepository.getComicByNumber(_currentComicNumber);
    if (comic != null) {
      _currentComicNumber = comic.number;
      if (comic.number > _lastComicNumber) {
        _lastComicNumber = comic.number;
      }
      _currentComicSubject.sink.add(comic);
    } else {
      _currentComicNumber = oldNumber;
    }
  }

  retrieveComicByNumber(int number) async {
    var savedComic = getSavedComic(number);

    if (savedComic != null) {
      _selectedComicSubject.sink.add(savedComic);
      return;
    }

    var comic = await _comicRepository.getComicByNumber(number);
    if (comic != null) _selectedComicSubject.sink.add(comic);
  }

  addToFavorite(Comic comic) {
    var savedComic = getSavedComic(comic.number);

    if (savedComic == null) {
      final comicBox = objectbox.store.box<Comic>();
      comicBox.put(comic);
      _savedComicsSubject.sink.add(comicBox.getAll());
    }
  }

  retrieveSavedComics() {
    final comicBox = objectbox.store.box<Comic>();
    _savedComicsSubject.sink.add(comicBox.getAll());
  }

  removeFromFavorites(int id) {
    final comicBox = objectbox.store.box<Comic>();
    comicBox.remove(id);
    _savedComicsSubject.sink.add(comicBox.getAll());
  }

  Comic? getSavedComic(int number) {
    final comicBox = objectbox.store.box<Comic>();
    final query = comicBox.query(Comic_.number.equals(number)).build();

    var savedComic = query.findUnique();
    query.close();

    if (savedComic != null) return savedComic;

    return null;
  }

  Future<bool> hasNewComic() async {
    var comic = await _comicRepository.fetchCurrentComic();
    if (comic != null && comic.number > _lastComicNumber) {
      _notificationBloc.saveNotification(comic.number, comic.title);
      return true;
    }
    return false;
  }
}
