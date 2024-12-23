import 'package:flutter/material.dart';
import 'package:news_app/controller/saved_screen_controller.dart';
import 'package:news_app/view/individual_news_screen/savedonTap_screen.dart';
import 'package:provider/provider.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<Map<String, dynamic>> _savedArticles = [];

  @override
  void initState() {
    super.initState();
    _loadSavedArticles();
  }

  Future<void> _loadSavedArticles() async {
    final articles = await context.read<SavedScreenController>().getSaved();
    setState(() {
      _savedArticles = articles;
    });
  }

  Future<void> _deleteArticle(int id) async {
    await context.read<SavedScreenController>().deleteSaved(id);
    _loadSavedArticles(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Articles"),
        backgroundColor: Colors.grey.shade300,
      ),
      body: _savedArticles.isEmpty
          ? const Center(
              child: Text(
                "No saved articles",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _savedArticles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SavedontapScreen(article: _savedArticles[index],),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Article Image
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade300,
                                image: _savedArticles[index]["urlToImage"] != null &&
                                        _savedArticles[index]["urlToImage"].isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            _savedArticles[index]["urlToImage"]),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: _savedArticles[index]["urlToImage"] == null ||
                                      _savedArticles[index]["urlToImage"].isEmpty
                                  ? const Icon(Icons.image, color: Colors.grey)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            // Article Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _savedArticles[index]["title"] ?? "No Title",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Author: ${_savedArticles[index]["author"] ?? "Unknown"}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Source: ${_savedArticles[index]["source"] ?? "Unknown"}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  _deleteArticle(_savedArticles[index]["id"]),
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
