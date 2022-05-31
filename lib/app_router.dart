import 'package:flutter/material.dart';
import 'package:xkcdbrowser/ui/explanation_web_view.dart';

import 'ui/favorites_page.dart';
import 'ui/home.dart';
import 'ui/saved_comic_page.dart';

class AppRouter {
  static const String home = '/';
  static const String favorites = 'favorites';
  static const String savedComic = 'savedComic';
  static const String explanationWebView = 'explanationWebView';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => const HomePage(title: 'xkcd browser'),
        );
      case favorites:
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => FavoritesPage(),
        );
      case savedComic:
        var argsMap = Map.from(settings.arguments as Map<String, dynamic>);
        var comic = argsMap["comic"];
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => SavedComicPage(comic: comic),
        );
      case explanationWebView:
        var argsMap = Map.from(settings.arguments as Map<String, dynamic>);
        String url = argsMap["url"];
        String title = argsMap["title"];
        return MaterialPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => ExplanationWebView(
            url: url,
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