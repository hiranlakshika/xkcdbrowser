import 'dart:async';

import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../blocs/comic_bloc.dart';
import '../blocs/notification_bloc.dart';
import '../models/change_notifier/application_error_notifier.dart';
import '../models/comic.dart';
import '../models/notification.dart';
import '../util/message_utils.dart';
import '../util/widget_keys.dart' as keys;
import '../util/custom_search_delegate.dart';
import 'comic_details_widget.dart';
import 'favorites_page.dart';
import 'notifications_page.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String appErrorListenerName = "HomeAppErrorListener";

  late final ComicBloc _comicBloc;
  late final NotificationBloc _notificationBloc;
  late final List<Widget> _widgetOptions;
  late final ApplicationErrorNotifier _applicationErrorNotifier;
  int _selectedIndex = 0;
  late String _title;
  Timer? _timer;

  @override
  initState() {
    super.initState();
    _comicBloc = GetIt.I<ComicBloc>();
    _notificationBloc = GetIt.I<NotificationBloc>();
    _applicationErrorNotifier = GetIt.I<ApplicationErrorNotifier>();
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

    // get notified when back-end services failed
    _applicationErrorNotifier.addListenerWithName(_showErrorMessage, appErrorListenerName);
  }

  @override
  dispose() {
    super.dispose();
    _timer?.cancel();
    _applicationErrorNotifier.removeListenerWithName(_showErrorMessage, appErrorListenerName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title).tr(),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => showSearch(context: context, delegate: CustomSearchDelegate()),
            icon: const Icon(Icons.search),
            tooltip: tr('search'),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
              key: Key(keys.homeButtonKey),
            ),
            label: tr('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.favorite,
              key: Key(keys.favoriteButtonKey),
            ),
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
        key: const Key(keys.notificationsButtonKey),
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

          return ComicDetailsWidget(
            comic: comic,
            isNavigationAvailable: true,
          );
        });
  }

  _showErrorMessage() {
    MessageUtils.showErrorInFlushBar(
      context,
      _applicationErrorNotifier.data,
    );
  }
}
