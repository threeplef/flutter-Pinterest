import 'dart:convert';

import 'package:flutter/material.dart';
import 'model/picture.dart';
import 'package:http/http.dart' as http;

class ImageSearchApp extends StatefulWidget {
  const ImageSearchApp({Key? key}) : super(key: key);

  @override
  State<ImageSearchApp> createState() => _ImageSearchAppState();
}

class _ImageSearchAppState extends State<ImageSearchApp> {
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
                child: FutureBuilder<List<Picture>>(
                  future: getImages(_query),
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

                    final images = snapshot.data!;

                    if (images.isEmpty) {
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
                      children: images
                          .where((e) => e.tags.contains(_query))
                          .map((Picture image) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            image.previewURL,
                            fit: BoxFit.cover,
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

  Future<List<Picture>> getImages(String query) async {
    Uri url = Uri.parse(
        'https://pixabay.com/api/?key=10711147-dc41758b93b263957026bdadb&q=$query&image_type=photo');

    http.Response response = await http.get(url);
    print('Response status: ${response.statusCode}');

    String jsonString = response.body;

    Map<String, dynamic> json = jsonDecode(jsonString);
    Iterable hits = json['hits'];
    return hits.map((e) => Picture.fromJson(e)).toList();
  }
}
