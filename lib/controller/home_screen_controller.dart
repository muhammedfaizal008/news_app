import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/appConfig.dart';
import 'package:news_app/dummydb.dart';
import 'package:news_app/model/top_head_lines_model.dart';
import 'package:news_app/view/individual_news_screen/individual_news_screen.dart';


class HomeScreenController with ChangeNotifier {
  NewsModel? topHeadLines;
  NewsModel? topNewsCategory;
  int selectedCategoryIndex = 0;
  bool isLoading = false;
  bool isLoadingCategory = false;  
  Future<void> getNewsbyCategory({String? category}) async {
    isLoading = true; 
    notifyListeners();

    final url = Uri.parse("${Appconfig.baseUrl}top-headlines?category=$category&apiKey=f641b6f49cf14b94934c9330845e4a04"
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        log("API Call Successful");
        topNewsCategory = NewsModelFromJson(response.body);
      } else {
        log("API Call Failed: ${response.statusCode}");
      }
    } catch (e) {
      log("Error: $e");
    }
    isLoading = false; 
    notifyListeners();
  }
  
  void onCategorySelection({required int clickedIndex}) {
    selectedCategoryIndex = clickedIndex;
    getNewsbyCategory(
      category:Dummydb.category[selectedCategoryIndex],
    );
    notifyListeners();
  }

  Future<void>getNewsHeadlines()async {
    final url=Uri.parse("${Appconfig.baseUrl}top-headlines?country=us&apiKey=f641b6f49cf14b94934c9330845e4a04");
    try{
      isLoadingCategory=true;
      notifyListeners();
      final response=await http.get(url);
      if(response.statusCode==200){
        topHeadLines=NewsModelFromJson(response.body);
      }else{
        log("API Call Failed: ${response.statusCode} - ${response.reasonPhrase}");
      }
    }
    catch(e){
    log("Error: $e");
    }
    isLoadingCategory=false;
    notifyListeners();
}
void onArticleTap(BuildContext context, {required int categoryIndex, required int articleIndex}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => IndividualNewsScreen(
        category: Dummydb.category[categoryIndex], 
        articleIndex: articleIndex, 
      ),
    ),
  );
}
void onCarouselArticleTap(BuildContext context, {required int articleIndex}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => IndividualNewsScreen(
        articleIndex: articleIndex,  
      ),
    ),
  );
}


}