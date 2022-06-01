import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../blocs/comic_bloc.dart';
import '../models/comic.dart';
import 'comic_details.dart';

class NotificationDetails extends StatelessWidget {
  final String title;
  final ComicBloc _comicBloc = GetIt.I<ComicBloc>();

  NotificationDetails({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<Comic?>(
          stream: _comicBloc.selectedComicStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              return const Text('something_wrong').tr();
            }

            var comic = snapshot.data;

            if (comic == null) {
              return const SizedBox();
            }

            return ComicDetails(
              comic: comic,
            );
          }),
    );
  }
}
