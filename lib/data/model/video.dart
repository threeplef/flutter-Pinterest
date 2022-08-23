class Video {
  final String pictureId;
  final String thumbnailSize = '256x166';
  final String tags;
  final Map<String, dynamic> videos;

  Video({
    required this.pictureId,
    required this.tags,
    required this.videos,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      pictureId: json['picture_id'] as String,
      tags: json['tags'] as String,
      videos: json['videos'] as Map<String, dynamic>,
    );
  }
}
