import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../app_router.dart';
import '../blocs/comic_bloc.dart';
import '../blocs/notification_bloc.dart';
import '../models/notification.dart';
import '../util/navigation_utils.dart';
import '../util/theme.dart';

class NotificationsPage extends StatelessWidget {
  final NotificationBloc _notificationBloc = GetIt.I<NotificationBloc>();
  final ComicBloc _comicBloc = GetIt.I<ComicBloc>();

  NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NotificationModel>>(
        stream: _notificationBloc.notificationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return const Text('something_wrong').tr();
          }

          var notifications = snapshot.data;

          if (notifications == null || notifications.isEmpty) {
            return const SizedBox();
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 8.0,
                  right: 8.0,
                ),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: XkcdColors.celadon,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        title: Text(
                          notifications[index].text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: notifications[index].isNew ? FontWeight.bold : null),
                        ),
                        subtitle: Text(getDate(notifications[index].dateTime)),
                        trailing: IconButton(
                            onPressed: () {
                              _notificationBloc.deleteNotification(notifications[index].id);
                            },
                            icon: const Icon(Icons.delete)),
                        onTap: () {
                          _notificationBloc.markAsRead(notifications[index].id);
                          _comicBloc.retrieveComicByNumber(notifications[index].comicNumber);
                          GetIt.I<NavigationUtils>().pushNamed(AppRouter.notificationDetails,
                              arguments: {'title': notifications[index].text});
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  String getDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    if (date == today) {
      return 'Today at ${DateFormat("hh:mm a").format(dateTime.toLocal())}';
    }
    return '${DateFormat("LLL d, y").format(dateTime.toLocal())} at ${DateFormat("hh:mm a").format(dateTime.toLocal())}';
  }
}
