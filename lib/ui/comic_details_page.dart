import 'package:flutter/material.dart';

import '../models/comic.dart';
import 'comic_details_widget.dart';

class ComicDetailsPage extends StatelessWidget {
  final Comic comic;
  final bool isFavoriteButtonAvailable;

  const ComicDetailsPage({Key? key, required this.comic, this.isFavoriteButtonAvailable = true}) : super(key: key);

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
      body: ComicDetailsWidget(
        comic: comic,
        isFavoriteButtonAvailable: isFavoriteButtonAvailable,
      ),
    );
  }
}
