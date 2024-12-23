import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SavedontapScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  const SavedontapScreen({super.key, required this.article});

  Future<void> onLaunchUrl(String? url) async {
    if (url == null || url.isEmpty) {
      log("Invalid or missing URL");
    }

    try {
      final uri = Uri.parse(url!);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        log("Could not open the link");
      }
    } catch (e) {
      log("Error opening the link");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        actions: [
          IconButton(
            onPressed: () {
              Share.share(article['url'] ?? 'No URL available');
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                  image: article["urlToImage"] != null
                      ? DecorationImage(
                          image: NetworkImage(article["urlToImage"]),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: article["urlToImage"] == null
                    ? const Icon(Icons.image, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                article["title"] ?? "No Title",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Author: ${article["author"] ?? "Unknown"}",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Source: ${article["source"] ?? "Unknown"}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                article["description"] ?? "No description available.",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                 onLaunchUrl(article["url"]);
                },
                child: const Text(
                  "Read More",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
