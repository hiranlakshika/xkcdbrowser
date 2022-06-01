import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:web_scraper/web_scraper.dart';

import '../app_router.dart';
import '../util/constants.dart' as constants;
import '../util/navigation_utils.dart';

class Explanation extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int comicNumber;

  const Explanation({Key? key, required this.title, required this.comicNumber, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final webScraper = WebScraper(constants.explanationWebUrl);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: webScraper.loadWebPage('${constants.explanationWebSubUrl}$comicNumber'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.hasData) {
              List<Map<String, dynamic>> elements = webScraper.getElement('.mw-parser-output', []);

              if (elements.isNotEmpty && elements[0]['title'] != null) {
                String explanation = _getExplanationText(elements[0]['title']);
                return ListView(
                  children: [
                    const SizedBox(
                      height: 8.0,
                    ),
                    CachedNetworkImage(imageUrl: imageUrl),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              GetIt.I<NavigationUtils>().pushNamed(AppRouter.explanationWebView, arguments: {
                                'url': '${constants.explanationWebUrl}${constants.explanationWebSubUrl}$comicNumber',
                                'title': title
                              });
                            },
                            child: const Text('Show original')),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(explanation),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                  ],
                );
              }
            }

            return const SizedBox();
          }),
    );
  }

  String _getExplanationText(String text) {
    final result = text.substring(0, text.indexOf('Transcript[edit]')).trim();
    return result;
  }
}
