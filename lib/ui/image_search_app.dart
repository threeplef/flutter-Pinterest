import 'package:flutter/material.dart';
import 'package:json_test/api/picture_api.dart';
import '../model/picture.dart';

class ImageSearchApp extends StatefulWidget {
  const ImageSearchApp({Key? key}) : super(key: key);

  @override
  State<ImageSearchApp> createState() => _ImageSearchAppState();
}

class _ImageSearchAppState extends State<ImageSearchApp> {
  final _pictureApi = PictureApi();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<List<Picture>>(
                  initialData: const [],
                  stream: _pictureApi.imagesStream,
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

                    final List<Picture> images = snapshot.data!;

                    if (images.isEmpty) {
                      return const Center(
                        child: Text('데이터가 0개입니다'),
                      );
                    }

                    return GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 2 : 4,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      children: images.map((Picture image) {
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
        Expanded(
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
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _pictureApi.fetchImages(_textController.text);
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
                fillColor: Theme
                    .of(context)
                    .colorScheme
                    .surfaceVariant,
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

  // class ImageGridView extends StatefulWidget {
  // const ImageGridView({Key? key}) : super(key: key);
  //
  // @override
  // State<ImageGridView> createState() => _ImageGridViewState();
  // }

  // class _ImageGridViewState extends State<ImageGridView> {
  // @override
  // Widget build(BuildContext context) {
  // final orientation = MediaQuery.of(context).orientation;
  //
  // return GridView(
  // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  // crossAxisCount:
  // orientation == Orientation.portrait ? 2 : 4,
  // mainAxisSpacing: 10,
  // crossAxisSpacing: 10,
  // ),
  // children: widget.images
  //     .where((e) => e.tags.contains(_query))
  //     .map((Picture image) {
  // return ClipRRect(
  // borderRadius: BorderRadius.circular(20),
  // child: Image.network(
  // image.previewURL,
  // fit: BoxFit.cover,
  // ),
  // );
  // }).toList(),
  // );
  // }
  // }
}
