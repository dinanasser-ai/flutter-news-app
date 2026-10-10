import 'package:flutter/material.dart';
import '../ApiService.dart';
import '../models/article.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final ApiService apiService = ApiService();

  List<Article> articles = [];
  bool isLoading = true;
  String? errorMessage;
  String selectedCategory = "all";
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNews();
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadNews() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await apiService.getNews(
        category: selectedCategory == "all" ? null : selectedCategory,
        query: searchQuery.isEmpty ? null : searchQuery,
      );

      setState(() {
        articles = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Something went wrong";
        isLoading = false;
      });
    }
  }
  void performSearch() {
    setState(() {
      searchQuery = searchController.text.trim();
    });

    loadNews();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News App"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) {
                performSearch();
              },
              decoration: InputDecoration(
                hintText: "Search news...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: performSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          buildCategories(),

          Expanded(
            child: buildBody(),
          ),
        ],
      ),
    );
  }
  Widget buildCategories() {
    final categories = [
      "all",
      "technology",
      "sports",
      "business",
    ];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 10,
            ),
            child: ChoiceChip(
              label: Text(
                category[0].toUpperCase() + category.substring(1),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedCategory = category;
                  });

                  loadNews();
                }
              },
            ),
          );
        },
      ),
    );
  }



  Widget buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
            ),
            const SizedBox(height: 10),
            Text(errorMessage!),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: loadNews,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (articles.isEmpty) {
      return const Center(
        child: Text("No articles found"),
      );
    }

    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];

        print("Title: ${article.title}");
        print("Image URL: ${article.imageUrl}");
        return Card(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 200,
                child: article.imageUrl != null
                    ? Image.network(
                  article.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.newspaper,
                          size: 60,
                        ),
                      ),
                    );
                  },
                )
                    : Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.newspaper,
                      size: 60,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    if (article.description != null)
                      Text(article.description!),

                    const SizedBox(height: 8),

                    if (article.pubDate != null)
                      Text(
                        article.pubDate!,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}