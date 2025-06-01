import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/media_item.dart';
import 'media_details_screen.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late Future<List<MediaItem>> _mediaItems;

  @override
  void initState() {
    _mediaItems = _fetchMediaItems();
    super.initState();
  }

  Future<List<MediaItem>> _fetchMediaItems() async {
    List<MediaItem> mediaItems = [];
    final ref = storageRef.ref().child('media'); // Adjust the path as needed

    // List all items in the 'media' folder
    final listResult = await ref.listAll();
    for (final item in listResult.items) {
      String url = await item.getDownloadURL();
      String fileType = item.name.split('.').last; // Get file extension
      mediaItems.add(MediaItem(url: url, type: fileType));
    }
    return mediaItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.project['name'])),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.project['description']),
              SizedBox(height: 10),
              TextButton(onPressed: () {}, child: Text('Upload Image')),
              TextButton(onPressed: () {}, child: Text('Upload Video')),
              FutureBuilder<List<MediaItem>>(
                future: _mediaItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No media found.'));
                  }

                  final mediaItems = snapshot.data!;

                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(
                        context,
                      ), // Responsive column count
                      childAspectRatio: 1, // Adjust aspect ratio as needed
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: mediaItems.length,
                    itemBuilder: (context, index) {
                      final mediaItem = mediaItems[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      MediaDetailScreen(mediaItem: mediaItem),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          child:
                              mediaItem.type == 'mp4' || mediaItem.type == 'mov'
                                  ? Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: mediaItem.url,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                        errorWidget:
                                            (context, url, error) =>
                                                Icon(Icons.error),
                                      ),
                                      Center(
                                        child: Icon(
                                          Icons.play_circle_fill,
                                          color: Colors.white,
                                          size: 64.0,
                                        ),
                                      ),
                                    ],
                                  )
                                  : CachedNetworkImage(
                                    imageUrl: mediaItem.url,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    errorWidget:
                                        (context, url, error) =>
                                            Icon(Icons.error),
                                  ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    // Adjust the number of columns based on screen width
    double width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 2; // 2 columns for small screens
    } else if (width < 1200) {
      return 3; // 3 columns for medium screens
    } else {
      return 4; // 4 columns for large screens
    }
  }
}
