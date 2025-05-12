import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/services/BlogServices.dart';

class TrendingScreen extends StatelessWidget {
  final Map<String, String> blogData;


   TrendingScreen({super.key, required this.blogData});

  @override
  Widget build(BuildContext context) {
    final BlogService blogService = BlogService();

    final screenHeight = MediaQuery.of(context).size.height;

    final String title = blogData['title'] ?? '';
    final String description = blogData['description'] ?? '';
    final String pubDate = blogData['pubDate'] ?? '';
    final String link = blogData['link'] ?? '';

    return  Scaffold(
      appBar: AppBar(
        title: const Text('Blog Details'),

      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Image.network(blogData['imageUrl']!),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                  pubDate,
                style: const TextStyle(color: Colors.grey),
              ),


              const Divider(height: 20),


              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _stripHtmlTags(description),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(link);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open the link')),
                    );
                  }
                },
                icon: const Icon(Icons.link),
                label: const Text('Read Full Article'),
              ),


            ],


          ),
        )
      ),
    );
  }

  String _stripHtmlTags(String htmlText) {
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}

