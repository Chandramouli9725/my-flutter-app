import 'package:flutter/cupertino.dart';

class MediaItem {
  final String url;
  final String type;

  MediaItem({required this.url, required this.type});

  factory MediaItem.fromMap(Map<String, dynamic> data) {
    try {
      return MediaItem(type: data['type'], url: data['url']);
    } catch (e) {
      debugPrint('error in model workout set result $e');
      return MediaItem(type: '', url: '');
    }
  }

  Map<String, dynamic> toMap() {
    return {'type': '', 'url': ''};
  }
}
