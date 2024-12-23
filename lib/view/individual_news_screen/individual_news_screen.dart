import 'package:flutter/material.dart';
import 'package:news_app/controller/individual_screen_controller.dart';
import 'package:news_app/controller/saved_screen_controller.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class IndividualNewsScreen extends StatefulWidget {
  final String? category;
  final int? articleIndex;
  final String? searchQuery;

  IndividualNewsScreen({
    this.searchQuery,
    this.articleIndex,
    this.category,
    super.key,
  });

  @override
  State<IndividualNewsScreen> createState() => _IndividualNewsScreenState();
}

class _IndividualNewsScreenState extends State<IndividualNewsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IndividualScreenController>().getIndividualNews(
            category: widget.category,
            searchQuery: widget.searchQuery,
          );
    });
    super.initState();
  }

  Future<void> onLaunchUrl(String? url) async {
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid or missing URL")),
      );
      return;
    }

    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open the link")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error opening the link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<IndividualScreenController>();
    final article = controller.selectedNews?.articles?[widget.articleIndex ?? 0];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [

          IconButton(
  onPressed: () async {
    final articleUrl = article?.url ?? "";

    final savedController = context.read<SavedScreenController>();
    if (controller.isArticleBookmarked(articleUrl)) {
      controller.toggleBookmark(articleUrl);
      final savedArticle = savedController.savedArticles.firstWhere(
        (element) => element['url'] == articleUrl,
        orElse: () => {},
      );

      if (savedArticle.isNotEmpty) {
        await savedController.deleteSaved(savedArticle['id']);
      }
    } else {
      controller.toggleBookmark(articleUrl);
      if (article != null) {
        await savedController.addToSaved(
          title: article.title ?? "No Title",
          description: article.description ?? "No Description",
          urlToImage: article.urlToImage ?? "",
          url: article.url ?? "",
          content: article.content ?? "",
          author: article.author ?? "Unknown Author",
          source: article.source?.name ?? "Unknown Source",
        );
      }
    }
  },
  icon: Icon(
    controller.isArticleBookmarked(article?.url ?? "")
        ? Icons.bookmark
        : Icons.bookmark_outline,
    color: controller.isArticleBookmarked(article?.url ?? "")
        ? Colors.blue
        : Colors.black,
      ),
    ),
      IconButton(
      onPressed: () {
        Share.share(article?.url ?? "No URL available");
      },
      icon: const Icon(Icons.share),
      ),
    ],
    backgroundColor: Colors.grey.shade300,
  ),
  body: controller.isloading
    ? const Center(child: CircularProgressIndicator())
    : SingleChildScrollView(
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
                  image: article?.urlToImage != null
                      ? DecorationImage(
                          image: NetworkImage(article!.urlToImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                article?.title ?? "",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Author: ${article?.author ?? "Unknown"}",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Source: ${article?.source?.name ?? "Unknown"}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                article?.description ?? "",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  onLaunchUrl(article?.url);
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
