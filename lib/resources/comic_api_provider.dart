import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/change_notifier/application_error_notifier.dart';
import '../models/comic.dart';

class ComicApiProvider {
  final ApplicationErrorNotifier _errorNotifier = GetIt.I<ApplicationErrorNotifier>();

  static const _baseApiUrl = 'https://www.xkcd.com/info.0.json';
  static const _subApiUrl = 'https://www.xkcd.com/{0}/info.0.json';

  Future<Comic?> fetchCurrentComic() async {
    try {
      final response = await Dio().get(_baseApiUrl);

      if (response.statusCode == HttpStatus.ok) {
        var comic = Comic.fromJson(response.data);
        return comic;
      } else {
        debugPrint('${response.statusCode}: ${response.toString()}');
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == HttpStatus.notFound) {
          _errorNotifier.data = tr('no_comics');
        }
      } else {
        _errorNotifier.data = tr('something_wrong');
      }
      debugPrint(e.toString());
      return null;
    }
    return null;
  }

  Future<Comic?> getComicByNumber(int number) async {
    String url = _subApiUrl.replaceAll('{0}', '$number');

    try {
      final response = await Dio().get(url);
      if (response.statusCode == HttpStatus.ok) {
        var comic = Comic.fromJson(response.data);
        return comic;
      } else {
        debugPrint('${response.statusCode}: ${response.toString()}');
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == HttpStatus.notFound) {
          _errorNotifier.data = tr('no_comics');
        }
      } else {
        _errorNotifier.data = tr('something_wrong');
      }
      debugPrint(e.toString());
      return null;
    }
    return null;
  }
}
