import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List articles = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    ambilBerita();
  }

  Future<void> ambilBerita() async {
    final data = await ApiService.getArticles();

    setState(() {
      articles = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceNews Core'),
      ),
      body: articles.isEmpty
          ? const Center(child: Text('Data berita kosong'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(articles[0]['image_url'] ?? ''),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    articles[0]['title'] ?? 'Headline News',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Berita Terbaru',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...articles.map((article) {
                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        article['image_url'] ?? '',
                        width: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image);
                        },
                      ),
                      title: Text(article['title'] ?? ''),
                      subtitle: Text(article['news_site'] ?? ''),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPage(article: article),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
    );
  }
}