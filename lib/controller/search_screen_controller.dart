import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:news_app/appConfig.dart';
import 'package:news_app/model/top_head_lines_model.dart';
import 'package:news_app/view/individual_news_screen/individual_news_screen.dart';

class SearchScreenController with ChangeNotifier{
  NewsModel? newsModel;
  bool isLoading = false;
  getSearchedNews(String searchedquery) async {
    isLoading = true; 
    notifyListeners();
    final url=Uri.parse(Appconfig.baseUrl+"everything?q=$searchedquery&apiKey=f641b6f49cf14b94934c9330845e4a04");
    try{
      final response=await http.get(url);
      if(response.statusCode==200){
        newsModel=NewsModelFromJson(response.body);
        notifyListeners();
      }
      else{
        print("Failed to fetch data");
      }
    }
    catch(e){
      print(e.toString());
    }
    isLoading = false;
    notifyListeners(); 
  }
  void onSearchScreenArticleTap(BuildContext context, {required int articleIndex, String? searchQuery}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => IndividualNewsScreen(
        articleIndex: articleIndex,
        category: "search", 
        searchQuery: searchQuery, 
      ),
    ),
  );
}

  
}