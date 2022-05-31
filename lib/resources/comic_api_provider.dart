import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/comic.dart';

class ComicApiProvider {
  static const _baseApiUrl = 'https://www.xkcd.com/info.0.json';
  static const _subApiUrl = 'https://www.xkcd.com/{0}/info.0.json';
  static const _explainXkcdUrl = 'https://www.explainxkcd.com/wiki/index.php/';

  Future<Comic?> fetchCurrentComic() async {
    final response = await Dio().get(_baseApiUrl);

    if (response.statusCode == HttpStatus.ok) {
      var comic = Comic.fromJson(response.data);
      return comic;
    } else {
      debugPrint('${response.statusCode}: ${response.toString()}');
    }
    return null;
  }
}
