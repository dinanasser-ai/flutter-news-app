import 'package:dio/dio.dart';
import 'models/article.dart';

class ApiService {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://newsdata.io/api/1",
    ),
  );

Future<List<Article>> getNews({
String? category,
String? query,
}) async {
final response = await dio.get(
"/latest",
queryParameters: {
"apikey": "pub_2b1c4b2d41f74ba492f40e812a5cf00c",
"language": "ar",
"country": "eg",
if (category != null) "category": category,
if (query != null && query.isNotEmpty) "q": query,
},
);

List<Article> articles = [];

for (var item in response.data["results"]) {
articles.add(Article.fromJson(item));
}

return articles;
}}