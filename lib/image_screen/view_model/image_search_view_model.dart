import 'package:flutter/material.dart';
import 'package:json_test/image_screen/api/picture_api.dart';
import 'package:json_test/image_screen/model/picture.dart';

class ImageSearchViewModel extends ChangeNotifier {
  final _pictureApi = PictureApi();

  List<Picture> imageList = [];

  void fetchImages(String query) async {
    imageList = await _pictureApi.getImages(query);
    notifyListeners();
  }
}
