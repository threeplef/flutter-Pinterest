import 'dart:convert';

import 'package:flutter/material.dart';
import 'data/images.dart';
import 'model/picture.dart';

class ImageSearchApp extends StatefulWidget {
  const ImageSearchApp({Key? key}) : super(key: key);

  @override
  State<ImageSearchApp> createState() => _ImageSearchAppState();
}

class _ImageSearchAppState extends State<ImageSearchApp> {
  final TextEditingController _textController = TextEditingController();
  List<Picture> images = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future initData() async {
    images = await getImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            Expanded(
              child: Center(
                child: images.isEmpty
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              itemCount: images.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.5 / 1,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                Picture image = images[index];
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      image.previewURL,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
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
              onSubmitted: _handleSubmitted,
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
        // const Spacer(),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
          child: Icon(Icons.notifications, size: 30, color: Colors.black45),
        ),
        const Icon(Icons.account_circle, size: 30, color: Colors.blueAccent),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
          child:
              Icon(Icons.keyboard_arrow_down, size: 30, color: Colors.black45),
        ),
      ],
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
  }

  Future<List<Picture>> getImages() async {
    await Future.delayed(const Duration(seconds: 2));

    String jsonString = imageData;

    Map<String, dynamic> json = jsonDecode(jsonString);
    Iterable hits = json['hits'];
    return hits.map((e) => Picture.fromJson(e)).toList();
  }
}
