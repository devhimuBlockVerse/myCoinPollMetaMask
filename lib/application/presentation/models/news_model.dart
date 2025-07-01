class NewsModel {
  final int id;
  final String title;
  final String slug;
  final String image;
  final String imageLarge;
  final int newsCategoryId;
  final List<String> tags;
  final bool status;
  final String shortDescription;
  final String description;
  final String createdAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.image,
    required this.imageLarge,
    required this.newsCategoryId,
    required this.tags,
    required this.status,
    required this.shortDescription,
    required this.description,
    required this.createdAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      image: json['image'],
      imageLarge: json['image_large'],
      newsCategoryId: json['news_category_id'],
      tags: List<String>.from(json['tags'] ?? []),
      status: json['status'] ?? false,
      shortDescription: json['short_description'],
      description: json['description'],
      createdAt: json['created_at'],
    );
  }
}
