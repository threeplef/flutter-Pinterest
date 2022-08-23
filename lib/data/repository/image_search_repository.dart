import 'package:flutter/material.dart';
import 'package:json_test/data/model/photo.dart';
import 'package:json_test/data/source/picture_source.dart';

class ImageSearchViewModel extends ChangeNotifier {
  final _pictureApi = PictureApi();

  List<Photo> imageList = [];

  void fetchImages(String query) async {
    imageList = await _pictureApi.getImages(query);
    notifyListeners();
  }
}
