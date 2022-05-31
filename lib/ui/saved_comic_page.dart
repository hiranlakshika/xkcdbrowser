import 'package:flutter/material.dart';
import 'package:xkcdbrowser/ui/comic_details.dart';

import '../models/comic.dart';

class SavedComicPage extends StatelessWidget {
  final Comic comic;

  const SavedComicPage({Key? key, required this.comic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          comic.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: ComicDetails(
        comic: comic,
        isFavoriteButtonAvailable: false,
      ),
    );
  }
}
