import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
 import 'package:xml/xml.dart' as xml;
import 'package:html/parser.dart' as html_parser;
import 'dart:convert';

class BlogService {
  static const String feedUrl = 'https://feeds.feedburner.com/CoinDesk';

  Future<List<Map<String, String>>> fetchBlogData() async {
    final response = await http.get(Uri.parse(feedUrl));


    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);
      final items = document.findAllElements('item');

      return items.map((node) {
        final description = node.getElement('description')?.text ?? '';

        // Parse image URL from <img> tag in the description HTML
        final htmlDoc = html_parser.parse(description);
        final imgElement = htmlDoc.querySelector('img');
        final imageUrl = imgElement?.attributes['src'] ?? '';

        return {
          'title': node.getElement('title')?.text ?? '',
          'link': node.getElement('link')?.text ?? '',
          'pubDate': node.getElement('pubDate')?.text ?? '',
          'description': description,
          'imageUrl': imageUrl,
          'source': 'CoinDesk',
        };
      }).toList();
    } else {
      throw Exception('Failed to load RSS feed');
    }
  }
}


