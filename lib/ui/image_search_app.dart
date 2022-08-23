import 'package:flutter/material.dart';
import 'package:json_test/data/model/photo.dart';
import 'package:json_test/data/repository/image_search_repository.dart';
import 'package:provider/provider.dart';

class ImageSearchApp extends StatefulWidget {
  const ImageSearchApp({Key? key}) : super(key: key);

  @override
  State<ImageSearchApp> createState() => _ImageSearchAppState();
}

class _ImageSearchAppState extends State<ImageSearchApp> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ImageSearchViewModel>();

    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
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
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              viewModel.fetchImages(_textController.text);
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
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
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
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          orientation == Orientation.portrait ? 2 : 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    children: viewModel.imageList.map((Photo image) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          image.previewURL,
                          fit: BoxFit.cover,
                        ),
                      );
                    }).toList(),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
