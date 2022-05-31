import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:xkcdbrowser/blocs/comic_bloc.dart';

import '../models/comic.dart';

class ComicApiProvider {
  static const _baseApiUrl = 'https://www.xkcd.com/info.0.json';
  static const _subApiUrl = 'https://www.xkcd.com/{0}/info.0.json';

  int _currentComicNumber = 0;

  Future<Comic?> fetchCurrentComic() async {
    final response = await Dio().get(_baseApiUrl);

    if (response.statusCode == HttpStatus.ok) {
      var comic = Comic.fromJson(response.data);
      _currentComicNumber = comic.number;
      return comic;
    } else {
      debugPrint('${response.statusCode}: ${response.toString()}');
    }
    return null;
  }

  Future<Comic?> changeComic(ComicChangeMode changeMode) async {
    String url;

    if (changeMode == ComicChangeMode.previous) {
      url = _subApiUrl.replaceAll('{0}', '${_currentComicNumber - 1}');
    } else {
      url = _subApiUrl.replaceAll('{0}', '${_currentComicNumber + 1}');
    }
    final response = await Dio().get(url);

    if (response.statusCode == HttpStatus.ok) {
      var comic = Comic.fromJson(response.data);
      _currentComicNumber = comic.number;
      return comic;
    } else {
      debugPrint('${response.statusCode}: ${response.toString()}');
    }
    return null;
  }
}
