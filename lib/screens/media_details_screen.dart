import 'package:flutter/material.dart';

import '../models/media_item.dart';
import '../widgets/video_player_widget.dart';

class MediaDetailScreen extends StatelessWidget {
  final MediaItem mediaItem;

  const MediaDetailScreen({super.key, required this.mediaItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Media Detail")),
      body:
          mediaItem.type == 'mp4' || mediaItem.type == 'mov'
              ? VideoPlayerWidget(url: mediaItem.url)
              : Image.network(mediaItem.url, fit: BoxFit.cover),
    );
  }
}
