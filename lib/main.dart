import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'app_router.dart';
import 'dependencies_locator.dart';
import 'models/objectbox/object_box.dart';
import 'ui/home.dart';
import 'util/navigation_utils.dart';
import 'util/theme.dart';

/// Provides access to the ObjectBox Store throughout the app.
late ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  injectDependencies();
  objectbox = await ObjectBox.create();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xkcd browser',
      theme: ThemeDataConfig.primaryTheme,
      home: const HomePage(title: 'xkcd browser'),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.home,
      navigatorKey: GetIt.I<NavigationUtils>().navigatorKey,
    );
  }
}
