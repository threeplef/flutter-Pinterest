import 'package:flutter/material.dart';
import 'package:json_test/video_api.dart';
import 'package:json_test/video_play.dart';
import 'model/video.dart';
import 'package:video_player/video_player.dart';

class VideoSearchApp extends StatefulWidget {
  const VideoSearchApp({Key? key}) : super(key: key);

  @override
  State<VideoSearchApp> createState() => _VideoSearchAppState();
}

class _VideoSearchAppState extends State<VideoSearchApp> {
  final _videoApi = VideoApi();
  final _textController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<List<Video>>(
                  future: _videoApi.getVideos(_query),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('에러가 발생했습니다'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('데이터가 없습니다'),
                      );
                    }

                    final videos = snapshot.data!;

                    if (videos.isEmpty) {
                      return const Center(
                        child: Text('데이터가 0개입니다'),
                      );
                    }

                    return GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      children: videos
                          .where((e) => e.tags.contains(_query))
                          .map((Video video) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VideoApp()),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              'https://i.vimeocdn.com/video/${video.pictureId}_${video.thumbnailSize}.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Row(
      children: [
        Image.network(
            'https://www.pngplay.com/wp-content/uploads/12/Pinterest-Logo-PNG-Images-HD.png',
            width: 60),
        const SizedBox(width: 5),
        const Text('홈',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(width: 5),
        const Icon(Icons.keyboard_arrow_down),
        SizedBox(
          width: 182,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 15, 5, 10),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(width: 2, color: Colors.lightBlueAccent),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _query = _textController.text;
                      _textController.clear();
                    });
                  },
                  child: const Icon(Icons.search),
                ),
                hintText: '검색',
                hintStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                contentPadding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                filled: true,
                fillColor: Colors.black12,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
          child: Icon(Icons.notifications, size: 30, color: Colors.black45),
        ),
        const Icon(Icons.account_circle, size: 30, color: Colors.blueAccent),
        const Icon(Icons.keyboard_arrow_down, size: 30, color: Colors.black45),
      ],
    );
  }
}
