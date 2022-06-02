import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../blocs/comic_bloc.dart';
import '../models/comic.dart';
import '../ui/custom_widgets.dart';

class CustomSearchDelegate extends SearchDelegate {
  final ComicBloc _comicBloc = GetIt.I<ComicBloc>();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (_isNumeric(query)) {
      return FutureBuilder<Comic?>(
          future: _comicBloc.getSearchResult(int.parse(query)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Center(child: const Text('no_search_result').tr());
            }

            var result = snapshot.data;

            if (result != null) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return XkcdCustomWidgets.xkcdCustomCard(
                      child: ListTile(
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: CachedNetworkImage(
                            imageUrl: result.imageUrl,
                            progressIndicatorBuilder: (_, __, ___) =>
                                const Center(child: CircularProgressIndicator.adaptive()),
                          ),
                        ),
                        title: Text(result.title),
                        subtitle: Text(
                          result.alt,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ),
              );
            }
            return Center(child: const Text('no_search_result').tr());
          });
    }
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }

  @override
  String get searchFieldLabel => tr('search_hint');

  @override
  TextInputType? get keyboardType => TextInputType.number;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  bool _isNumeric(String s) => int.tryParse(s) != null;
}
