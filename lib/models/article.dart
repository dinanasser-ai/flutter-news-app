class Article {
  final String title;
  final String? description;
  final String? imageUrl;

  final String? pubDate;
  final String? link;
  final List<String> category;
  final String? sourceName;

  Article({
    required this.title,
    this.description,
    this.imageUrl,
    this.pubDate,
    this.link,
    this.category = const [],
    this.sourceName,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'],
      imageUrl: json['image_url'],
      pubDate: json['pubDate'],
      link: json['link'],
      category: List<String>.from(json['category'] ?? []),
      sourceName: json['source_name'],
    );
  }
}