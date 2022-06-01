import 'dart:async';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../blocs/comic_bloc.dart';
import '../blocs/notification_bloc.dart';
import '../models/comic.dart';
import '../models/notification.dart';
import '../util/message_utils.dart';
import '../util/theme.dart';
import 'comic_details.dart';
import 'favorites_page.dart';
import 'notifications_page.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ComicBloc _comicBloc = GetIt.I<ComicBloc>();
  final NotificationBloc _notificationBloc = GetIt.I<NotificationBloc>();
  final TextEditingController _searchTextController = TextEditingController();
  late final List<Widget> _widgetOptions;
  int _selectedIndex = 0;
  late String _title;
  Timer? _timer;

  @override
  initState() {
    super.initState();
    _comicBloc.fetchCurrentComic();
    _comicBloc.retrieveSavedComics();
    _notificationBloc.retrieveNotifications();
    _startTimer();

    _widgetOptions = <Widget>[
      _comicDetailBuilder(),
      FavoritesPage(),
      NotificationsPage(),
    ];

    _title = widget.title;
  }

  @override
  dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title).tr(),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AnimSearchBar(
              width: MediaQuery.of(context).size.width - 20,
              color: XkcdColors.celadon,
              textController: _searchTextController,
              closeSearchOnSuffixTap: true,
              suffixIcon: const Icon(Icons.search),
              onSuffixTap: () {
                setState(() {
                  _searchTextController.clear();
                });
              },
            ),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: tr('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: tr('favorites'),
          ),
          BottomNavigationBarItem(
            icon: _notificationIconBuilder(),
            label: tr('notifications'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  _onItemTapped(int index) {
    switch (index) {
      case 0:
        _comicBloc.fetchCurrentComic();
        _title = tr('title');
        break;
      case 1:
        _comicBloc.retrieveSavedComics();
        _title = tr('favorites');
        break;
      case 2:
        _title = tr('notifications');
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  //This timer checks new comics in every five minutes.
  _startTimer() {
    _timer = Timer.periodic(
      const Duration(minutes: 5),
      (timer) {
        _comicBloc.hasNewComic().then((value) {
          if (value && mounted) {
            MessageUtils.showMessageInFlushBar(context, tr('new_comic_found'));
          }
        });
      },
    );
  }

  Widget _notificationIconBuilder() {
    return StreamBuilder<List<NotificationModel>>(
        stream: _notificationBloc.notificationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError || !snapshot.hasData) {
            return const Icon(Icons.notifications);
          }

          var notifications = snapshot.data;

          if (notifications != null) {
            int notificationsCount = notifications.where((element) => element.isNew).length;

            if (notificationsCount == 0) return const Icon(Icons.notifications);

            String notificationValue = notificationsCount > 9 ? '9+' : notificationsCount.toString();

            return Badge(
              badgeContent: Text(
                notificationValue,
                style: TextStyle(fontSize: notificationsCount > 9 ? 10 : null),
              ),
              position: BadgePosition.topEnd(),
              child: const Icon(Icons.notifications),
            );
          }
          return const Icon(Icons.notifications);
        });
  }

  Widget _comicDetailBuilder() {
    return StreamBuilder<Comic?>(
        stream: _comicBloc.currentComicStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return const Text('something_wrong').tr();
          }

          var comic = snapshot.data;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  top: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () async => await _comicBloc.changeComic(ComicChangeMode.previous),
                        child: const Text('previous').tr()),
                    ElevatedButton(
                        onPressed: () async => await _comicBloc.changeComic(ComicChangeMode.next),
                        child: const Text('next').tr()),
                  ],
                ),
              ),
              Expanded(
                child: ComicDetails(
                  comic: comic,
                ),
              ),
            ],
          );
        });
  }
}
