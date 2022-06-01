import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:xkcdbrowser/repository/comic_repository.dart';
import 'package:xkcdbrowser/resources/comic_api_provider.dart';

GetIt locator = GetIt.instance;

void main() {
  locator.registerLazySingleton<ComicApiProvider>(() => ComicApiProvider());
  locator.registerLazySingleton<ComicRepository>(() => ComicRepository());

  var comicRepo = GetIt.I<ComicRepository>();

  int previousComicNumber = 0;

  group("fetch comics testing", () {
    test('fetch initial comic', () async {
      var comic = await comicRepo.fetchCurrentComic();

      // assert
      expect(comic, isNotNull);
      previousComicNumber = comic!.number;
    });

    test('fetch previous comic', () async {
      var comic = await comicRepo.getComicByNumber(previousComicNumber - 1);

      // assert
      expect(comic, isNotNull);
    });
  });
}
