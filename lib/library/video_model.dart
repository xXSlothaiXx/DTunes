class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;
  final String videoAdd;

  Video({
    this.id,
    this.title,
    this.thumbnailUrl,
    this.channelTitle,
    this.videoAdd,
  });

  factory Video.fromMap(Map<String, dynamic> snippet, String videoId) {
    return Video(
      id: snippet['channelTitle'],
      title: snippet['title'],
      thumbnailUrl: snippet['thumbnails']['high']['url'],
      channelTitle: snippet['channelTitle'],
      videoAdd: videoId,
    );
  }
}