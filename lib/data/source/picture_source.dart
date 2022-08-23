import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:json_test/data/model/photo.dart';

class PhotoApi {
  PhotoApi() {
    fetchImages('');
  }

  final _imageStreamController = StreamController<List<Photo>>();

  Stream<List<Photo>> get imagesStream => _imageStreamController.stream;

  void fetchImages(String query) async {
    List<Photo> imageList = await getImages(query);
    _imageStreamController.add(imageList);
  }

  Future<List<Photo>> getImages(String query) async {
    Uri url = Uri.parse(
        'https://pixabay.com/api/?key=10711147-dc41758b93b263957026bdadb&q=$query&image_type=photo');

    http.Response response = await http.get(url);

    String jsonString = response.body;

    Map<String, dynamic> json = jsonDecode(jsonString);
    Iterable hits = json['hits'];
    return hits.map((e) => Photo.fromJson(e)).toList();
  }
}
