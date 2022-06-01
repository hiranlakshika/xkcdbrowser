import 'package:rxdart/rxdart.dart';

import '../main.dart';
import '../models/notification.dart';
import '../objectbox.g.dart';
import 'bloc_holder.dart';

class NotificationBloc extends BlocBase {
  /* Rxdart objects */
  final _notificationsSubject = BehaviorSubject<List<NotificationModel>>();

  /* Streams */
  Stream<List<NotificationModel>> get notificationsStream => _notificationsSubject.stream;

  @override
  void dispose() {
    _notificationsSubject.close();
  }

  saveNotification(int comicNumber, String title) {
    var savedNotification = getSavedNotification(comicNumber);
    if (savedNotification == null) {
      final notificationBox = objectbox.store.box<NotificationModel>();
      notificationBox.put(NotificationModel(
        text: title,
        comicNumber: comicNumber,
        dateTime: DateTime.now(),
        isNew: true,
      ));
      _notificationsSubject.sink.add(notificationBox.getAll());
    }
  }

  retrieveNotifications() {
    final notificationBox = objectbox.store.box<NotificationModel>();
    _notificationsSubject.sink.add(notificationBox.getAll());
  }

  deleteNotification(int id) {
    final notificationBox = objectbox.store.box<NotificationModel>();
    notificationBox.remove(id);
    _notificationsSubject.sink.add(notificationBox.getAll());
  }

  markAsRead(int id) {
    final notificationBox = objectbox.store.box<NotificationModel>();
    var notification = notificationBox.get(id);
    if (notification != null) {
      notification.isNew = false;
      notificationBox.put(notification);
      _notificationsSubject.sink.add(notificationBox.getAll());
    }
  }

  NotificationModel? getSavedNotification(int comicNumber) {
    final notificationBox = objectbox.store.box<NotificationModel>();
    final query = notificationBox.query(NotificationModel_.comicNumber.equals(comicNumber)).build();

    var savedNotification = query.findUnique();
    query.close();

    if (savedNotification != null) return savedNotification;

    return null;
  }
}
