import 'package:objectbox/objectbox.dart';

@Entity()
class NotificationModel {
  int id = 0;

  NotificationModel({
    required this.text,
    required this.comicNumber,
    required this.dateTime,
    required this.isNew,
  });

  late final String text;
  late final int comicNumber;
  late final DateTime dateTime;
  late bool isNew;
}
