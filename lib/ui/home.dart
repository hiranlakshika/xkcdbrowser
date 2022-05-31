import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../app_router.dart';
import '../blocs/comic_bloc.dart';
import '../models/comic.dart';
import '../util/navigation_utils.dart';
import 'comic_details.dart';

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
          onPressed: () async => await _comicBloc.changeComic(ComicChangeMode.previous),
          icon: const Icon(Icons.arrow_left),
          tooltip: 'Previous',
        ),
        actions: [
          IconButton(
            onPressed: () async => await _comicBloc.changeComic(ComicChangeMode.next),
            icon: const Icon(Icons.arrow_right),
            tooltip: 'Next',
          ),
        ],
      ),
      body: StreamBuilder<Comic?>(
          stream: _comicBloc.currentComicStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              return const Text(
                'Something went wrong',
              );
            }

            var comic = snapshot.data;

            return ComicDetails(
              comic: comic,
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
              onPressed: () {
                _comicBloc.retrieveSavedComics();
                GetIt.I<NavigationUtils>().pushNamed(
                  AppRouter.favorites,
                );
              },
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
