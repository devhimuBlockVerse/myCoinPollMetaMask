import 'dart:convert';
import 'package:http/http.dart' as http;
class BlogPost {

  final String title;
  final String publishedAt;
  final String source;
  final String? image;
  final String? url;

  BlogPost({
    required this.title,
    required this.publishedAt,
    required this.source,
    this.image,
    this.url,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      title: json['title'] ?? '',
      publishedAt: json['published_at'] ?? '',
      source: json['source']['title'] ?? 'Unknown Source',
      image: json['screenshot'] ?? null,
      url: json['url'] ?? '',
    );
  }
}

