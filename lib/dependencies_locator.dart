import 'package:get_it/get_it.dart';

import 'blocs/comic_bloc.dart';
import 'repository/comic_repository.dart';
import 'resources/comic_api_provider.dart';
import 'util/navigation_utils.dart';

injectDependencies() {
  //Api Provider
  GetIt.I.registerLazySingleton(() => ComicApiProvider());

  // Repositories
  GetIt.I.registerLazySingleton(() => ComicRepository());

  // Singleton Blocs
  GetIt.I.registerLazySingleton(() => ComicBloc());

  // Navigation Utils
  GetIt.I.registerLazySingleton(() => NavigationUtils());

}
