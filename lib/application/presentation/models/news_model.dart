class ExternalLink {
  final String pr;
  final String date;
  final String link;
  final String slug;
  final String photo;
  final String title;

  ExternalLink({
    required this.pr,
    required this.date,
    required this.link,
    required this.slug,
    required this.photo,
    required this.title,
  });

  factory ExternalLink.fromJson(Map<String, dynamic> json) {
    return ExternalLink(
      pr: json['pr'] ?? '',
      date: json['date'] ?? '',
      link: json['link'] ?? '',
      slug: json['slug'] ?? '',
      photo: json['photo'] ?? '',
      title: json['title'] ?? '',
    );
  }
}

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
  final List<ExternalLink>? externalLinks;

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
    this.externalLinks,
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
      externalLinks: json['external_links'] != null
          ? (json['external_links'] as List)
          .map((link) => ExternalLink.fromJson(link))
          .toList()
          : null,
    );
  }

  // Added method to convert back to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'image': image,
      'image_large': imageLarge,
      'news_category_id': newsCategoryId,
      'tags': tags,
      'status': status,
      'short_description': shortDescription,
      'description': description,
      'created_at': createdAt,
      'external_links': externalLinks?.map((link) => link.toJson()).toList(),
    };
  }
}

extension ExternalLinkExtension on ExternalLink {
  Map<String, dynamic> toJson() {
    return {
      'pr': pr,
      'date': date,
      'link': link,
      'slug': slug,
      'photo': photo,
      'title': title,
    };
  }
}

