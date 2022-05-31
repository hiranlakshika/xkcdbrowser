import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_view/photo_view.dart';

import '../blocs/comic_bloc.dart';
import '../models/comic.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ComicBloc _comicBloc = GetIt.I<ComicBloc>();

  @override
  initState() {
    super.initState();
    _comicBloc.fetchCurrentComic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_left),
          tooltip: 'Previous',
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_right),
            tooltip: 'Next',
          ),
        ],
      ),
      body: StreamBuilder<Comic?>(
          stream: _comicBloc.currentComicStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator.adaptive();
            }

            if (snapshot.hasError) {
              return const Text(
                'Something went wrong',
              );
            }

            var comic = snapshot.data;

            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView(
                children: <Widget>[
                  Text(
                    comic?.alt ?? '',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
                      const Text('Add to favorites'),
                    ],
                  ),
                  if (comic?.imageUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: PhotoView(
                          imageProvider: NetworkImage(comic!.imageUrl),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => _comicBloc.fetchCurrentComic(),
              icon: const Icon(Icons.home),
              tooltip: 'Home',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite),
              tooltip: 'Favorites',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
              tooltip: 'Search',
            ),
          ],
        ),
      ),
    );
  }
}
