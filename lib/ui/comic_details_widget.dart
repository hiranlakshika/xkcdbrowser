import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

import '../app_router.dart';
import '../blocs/comic_bloc.dart';
import '../models/comic.dart';
import '../util/constants.dart' as constants;
import '../util/message_utils.dart';
import '../util/navigation_utils.dart';
import '../util/widget_keys.dart' as keys;

class ComicDetailsWidget extends StatelessWidget {
  final Comic? comic;
  final bool isFavoriteButtonAvailable;
  final bool isNavigationAvailable;
  final ComicBloc _comicBloc = GetIt.I<ComicBloc>();

  ComicDetailsWidget(
      {Key? key, required this.comic, this.isFavoriteButtonAvailable = true, this.isNavigationAvailable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView(
        children: <Widget>[
          Text(
            comic?.title ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              comic?.alt ?? '',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isNavigationAvailable)
                IconButton(
                    key: const Key(keys.previousButtonKey),
                    tooltip: tr('previous'),
                    onPressed: () async => await _comicBloc.changeComic(ComicChangeMode.previous),
                    icon: const Icon(Icons.arrow_left)),
              if (isFavoriteButtonAvailable)
                StreamBuilder<List<Comic>>(
                    stream: _comicBloc.savedComicStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      }

                      var savedComics = snapshot.data;

                      if (savedComics == null || !savedComics.any((element) => element.number == comic?.number)) {
                        return IconButton(
                          key: const Key(keys.addToFavoriteButtonKey),
                          onPressed: () {
                            if (comic != null) {
                              MessageUtils.showMessageInFlushBar(
                                  context, '${comic!.title} ${tr('added_to_favorites')}');
                              _comicBloc.addToFavorite(comic!);
                            }
                          },
                          icon: const Icon(Icons.favorite_border),
                          tooltip: tr('add_to_favorites'),
                        );
                      }
                      return const SizedBox();
                    }),
              IconButton(
                key: const Key(keys.shareButtonKey),
                onPressed: () {
                  if (comic != null) {
                    Share.share('${tr('share_message')} ${constants.xkcdWebUrl}/${comic!.number}/',
                        subject: tr('share_message'));
                  }
                },
                icon: const Icon(Icons.share),
                tooltip: tr('share'),
              ),
              IconButton(
                key: const Key(keys.infoButtonKey),
                onPressed: () {
                  GetIt.I<NavigationUtils>().pushNamed(AppRouter.explanation,
                      arguments: {'comicNumber': comic!.number, 'title': comic!.title, 'imageUrl': comic!.imageUrl});
                },
                icon: const Icon(Icons.info_outline),
                tooltip: tr('explain'),
              ),
              if (isNavigationAvailable)
                IconButton(
                    key: const Key(keys.nextButtonKey),
                    tooltip: tr('next'),
                    onPressed: () async => await _comicBloc.changeComic(ComicChangeMode.next),
                    icon: const Icon(Icons.arrow_right)),
            ],
          ),
          if (comic?.imageUrl != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: PhotoView(
                  backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                  loadingBuilder: (context, event) => const Center(child: CircularProgressIndicator.adaptive()),
                  basePosition: Alignment.center,
                  imageProvider: CachedNetworkImageProvider(comic!.imageUrl),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
