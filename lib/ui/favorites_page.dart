import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../app_router.dart';
import '../blocs/comic_bloc.dart';
import '../models/comic.dart';
import '../util/navigation_utils.dart';
import 'custom_widgets.dart';

class FavoritesPage extends StatelessWidget {
  final ComicBloc _comicBloc = GetIt.I<ComicBloc>();

  FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Comic>>(
        stream: _comicBloc.savedComicStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return const Text('something_wrong').tr();
          }

          var comics = snapshot.data;

          if (comics == null || comics.isEmpty) {
            return const SizedBox();
          }

          return ListView.builder(
            itemCount: comics.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 8.0,
                  right: 8.0,
                ),
                child: XkcdCustomWidgets.xkcdCustomCard(
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: CachedNetworkImage(
                        imageUrl: comics[index].imageUrl,
                      ),
                    ),
                    title: Text(
                      comics[index].alt,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          _comicBloc.removeFromFavorites(comics[index].id);
                        },
                        icon: const Icon(Icons.delete)),
                    onTap: () {
                      GetIt.I<NavigationUtils>().pushNamed(AppRouter.savedComic, arguments: {'comic': comics[index]});
                    },
                  ),
                ),
              );
            },
          );
        });
  }
}
