import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/catergories_news_model.dart';
import 'package:news_app/models/news_channel_headline_model.dart';

class NewsServices {
  Future<NewsChannelHeadlineModel> fetchNewsHeadlines(
      String channelName) async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=$channelName&apiKey=9f07e44347b44d968df3946b6857f088";
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return NewsChannelHeadlineModel.fromJson(data);
    }
    throw Exception("Error");
  }

  Future<CatergoriesNewsModel> fetchCategooriesNewsApi(String category) async {
    String url =
        "https://newsapi.org/v2/everything?q=$category&apiKey=9f07e44347b44d968df3946b6857f088";
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return CatergoriesNewsModel.fromJson(data);
    }
    throw Exception("Error");
  }
}
