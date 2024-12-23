// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:news_app/controller/search_screen_controller.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();


    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        context.read<SearchScreenController>().newsModel = null; 
        context.read<SearchScreenController>().notifyListeners();
      }
    });
  }

  void _search() {
    final searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      context.read<SearchScreenController>().getSearchedNews(searchQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    final x=context.read<SearchScreenController>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search for news...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onFieldSubmitted: (_) => _search(),  
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      
                    },
                    icon: Icon(Icons.filter_list_outlined),
                  ),
                ],
              ),

              Consumer<SearchScreenController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return Expanded(child: Center(child: CircularProgressIndicator()));
                  } else if (controller.newsModel == null ||
                      controller.newsModel?.articles?.isEmpty == true) {
                    return Expanded(child: Center(child: Text("Search for news")));
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: controller.newsModel?.articles?.length ?? 0,
                        itemBuilder: (context, index) {
                          final article = controller.newsModel?.articles?[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                x.onSearchScreenArticleTap(
                                  context,
                                  articleIndex: index,
                                  searchQuery: _searchController.text.trim(), 
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(article?.urlToImage ?? ''),
                                          ),
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              article?.title ?? "",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              article?.author ?? "Unknown Author",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
