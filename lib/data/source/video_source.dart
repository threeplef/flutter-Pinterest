import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:json_test/data/model/video.dart';

class VideoApi {
  VideoApi() {
    fetchVideos('');
  }

  final _videoStreamController = StreamController<List<Video>>();

  Stream<List<Video>> get videosStream => _videoStreamController.stream;

  void fetchVideos(String query) async {
    List<Video> videoList = await getVideos(query);
    _videoStreamController.add(videoList);
  }

  Future<List<Video>> getVideos(String query) async {
    Uri url = Uri.parse(
        'https://pixabay.com/api/videos/?key=10711147-dc41758b93b263957026bdadb&q=$query');

    http.Response response = await http.get(url);

    String jsonString = response.body;

    Map<String, dynamic> json = jsonDecode(jsonString);
    Iterable hits = json['hits'];
    return hits.map((e) => Video.fromJson(e)).toList();
  }
}
