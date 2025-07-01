class BlogModel {
  final String imageUrl;
  final String source;
  final String date;
  final String title;
  final String description;

  BlogModel({
    required this.imageUrl,
    required this.source,
    required this.date,
    required this.title,
    required this.description,
  });

  factory BlogModel.fromJson(Map<String, String> json) {
    return BlogModel(
      imageUrl: json['imageUrl']!,
      source: json['source']!,
      date: json['date']!,
      title: json['title']!,
      description: json['description']!,
    );
  }
}
