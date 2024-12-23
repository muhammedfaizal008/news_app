import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/appConfig.dart';
import 'package:news_app/model/top_head_lines_model.dart';

class IndividualScreenController with ChangeNotifier {
  NewsModel? selectedNews;
  int? currentArticleIndex;
  bool isloading = false;
  bool isBookmarked=false;
   Map<String, bool> bookmarks = {};

  Future<void> getIndividualNews({String? category, String? searchQuery}) async {

    final url = Uri.parse(
      category == null
          ? "${Appconfig.baseUrl}top-headlines?country=us&apiKey=f641b6f49cf14b94934c9330845e4a04"
          : category == "search" && searchQuery != null
              ? "${Appconfig.baseUrl}everything?q=$searchQuery&apiKey=f641b6f49cf14b94934c9330845e4a04"
              : "${Appconfig.baseUrl}top-headlines?category=$category&apiKey=f641b6f49cf14b94934c9330845e4a04",
    );

    try {
      isloading = true;
      notifyListeners();

      final response = await http.get(url);

      if (response.statusCode == 200) {
        selectedNews = NewsModel.fromJson(json.decode(response.body));
      } else {
        log("API Call Failed: ${response.statusCode}");
      }
    } catch (e) {
      log("Error: $e");
    } finally {
      isloading = false;
      notifyListeners();
    }
  }
  
  
  void toggleBookmark(String url) {
    if (bookmarks.containsKey(url)) {
      bookmarks[url] = !(bookmarks[url] ?? false); 
    } else {
      bookmarks[url] = true; 
    }
    notifyListeners();
  }

  bool isArticleBookmarked(String url) {
    return bookmarks[url] ?? false; 
  }
  
}
