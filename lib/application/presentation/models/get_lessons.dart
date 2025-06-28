
class LessonModel {
  final int id;
  final String title;
  final String slug;
  final String image;
  final String imageLarge;
  final int lessonCategoryId;
  final String videoId;
  final bool status;
  final String shortDescription;
  final String description;
  final String createdAt;
  final LessonCategory category;

  LessonModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.image,
    required this.imageLarge,
    required this.lessonCategoryId,
    required this.videoId,
    required this.status,
    required this.shortDescription,
    required this.description,
    required this.category,
    required this.createdAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      image: json['image'],
      imageLarge: json['image_large'],
      lessonCategoryId: json['lesson_category_id'],
      videoId: json['video_id'],
      status: json['status'],
      shortDescription: json['short_description'],
      description: json['description'],
      createdAt: json['created_at'],
      category: LessonCategory.fromJson(json['category']),
    );
  }
}

class LessonCategory {
  final String name;
  final String slug;
  final int status;

  LessonCategory({
    required this.name,
    required this.slug,
    required this.status,
  });

  factory LessonCategory.fromJson(Map<String, dynamic> json) {
    return LessonCategory(
      name: json['name'],
      slug: json['slug'],
      status: json['status'],
    );
  }
}