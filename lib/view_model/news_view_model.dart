import 'package:news_app/models/catergories_news_model.dart';
import 'package:news_app/models/news_channel_headline_model.dart';
import 'package:news_app/services/news_service.dart';

class NewsViewModel {
  final _api = NewsServices();
  Future<NewsChannelHeadlineModel> fetchNewsHeadlines(
      String channelName) async {
    final response = await _api.fetchNewsHeadlines(channelName);
    return response;
  }

  Future<CatergoriesNewsModel> fetchCategoryNews(String category) async {
    final response = await _api.fetchCategooriesNewsApi(category);
    return response;
  }
}
