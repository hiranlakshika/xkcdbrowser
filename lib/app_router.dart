import 'package:flutter/material.dart';

import 'ui/explanation.dart';
import 'ui/explanation_web_view.dart';
import 'ui/home.dart';
import 'ui/notification_details_page.dart';
import 'ui/comic_details_page.dart';

class AppRouter {
  //constants for named routes
  static const String home = '/';
  static const String comicDetailsPage = 'comicDetailsPage';
  static const String explanation = 'explanation';
  static const String explanationWebView = 'explanationWebView';
  static const String notificationDetails = 'notificationDetails';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => const HomePage(title: 'title'),
        );
      case comicDetailsPage:
        var argsMap = Map.from(settings.arguments as Map<String, dynamic>);
        var comic = argsMap['comic'];
        bool isFavoriteButtonAvailable = argsMap['isFavoriteButtonAvailable'] ?? false;
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => ComicDetailsPage(
            comic: comic,
            isFavoriteButtonAvailable: isFavoriteButtonAvailable,
          ),
        );
      case explanation:
        var argsMap = Map.from(settings.arguments as Map<String, dynamic>);
        int comicNumber = argsMap['comicNumber'];
        String title = argsMap['title'];
        String imageUrl = argsMap['imageUrl'];
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => Explanation(
            title: title,
            comicNumber: comicNumber,
            imageUrl: imageUrl,
          ),
        );
      case explanationWebView:
        var argsMap = Map.from(settings.arguments as Map<String, dynamic>);
        String url = argsMap['url'];
        String title = argsMap['title'];
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => ExplanationWebView(
            url: url,
            title: title,
          ),
        );
      case notificationDetails:
        var argsMap = Map.from(settings.arguments as Map<String, dynamic>);
        String title = argsMap['title'];
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => NotificationDetails(
            title: title,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) {
            return Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            );
          },
        );
    }
  }
}
