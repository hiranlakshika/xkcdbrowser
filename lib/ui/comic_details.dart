import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xkcdbrowser/models/comic.dart';

import '../app_router.dart';
import '../blocs/comic_bloc.dart';
import '../util/navigation_utils.dart';

class ComicDetails extends StatelessWidget {
  final Comic? comic;
  final bool isFavoriteButtonAvailable;
  final ComicBloc _comicBloc = GetIt.I<ComicBloc>();

  ComicDetails({Key? key, required this.comic, this.isFavoriteButtonAvailable = true}) : super(key: key);

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
              if (isFavoriteButtonAvailable)
                IconButton(
                  onPressed: () {
                    if (comic != null) {
                      _comicBloc.addToFavorite(comic!);
                    }
                  },
                  icon: const Icon(Icons.favorite_border),
                  tooltip: 'Add to favorites',
                ),
              IconButton(
                onPressed: () {
                  if (comic != null) {
                    Share.share('Hey check this xkcd comic https://xkcd.com/${comic!.number}/',
                        subject: 'Hey check this xkcd comic');
                  }
                },
                icon: const Icon(Icons.share),
                tooltip: 'Share',
              ),
              IconButton(
                onPressed: () {
                  GetIt.I<NavigationUtils>().pushNamed(AppRouter.explanationWebView, arguments: {
                    'url': 'https://www.explainxkcd.com/wiki/index.php/${comic!.number}',
                    'title': comic!.title
                  });
                },
                icon: const Icon(Icons.info_outline),
                tooltip: 'Explain',
              ),
            ],
          ),
          if (comic?.imageUrl != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: PhotoView(
                  backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                  loadingBuilder: (context, event) => Center(
                    child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: event == null ? 0 : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 0),
                      ),
                    ),
                  ),
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