import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPage extends StatefulWidget {
  final Map article;

  const DetailPage({super.key, required this.article});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool favorite = false;

  Future<void> simpanFavorite() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    await FirebaseFirestore.instance.collection('favorites').add({
      'userId': user.uid,
      'articleId': widget.article['id'].toString(),
      'title': widget.article['title'] ?? '',
      'imageUrl': widget.article['image_url'] ?? '',
      'newsSite': widget.article['news_site'] ?? '',
      'summary': widget.article['summary'] ?? '',
      'createdAt': Timestamp.now(),
    });

    setState(() {
      favorite = true;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Berhasil disimpan ke favorite')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Berita'),
        actions: [
          IconButton(
            onPressed: simpanFavorite,
            icon: Icon(
              favorite ? Icons.favorite : Icons.favorite_border,
              color: favorite ? Colors.red : Colors.white,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.network(
            article['image_url'] ?? '',
            height: 240,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image, size: 120);
            },
          ),
          const SizedBox(height: 20),
          Text(
            article['title'] ?? '',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            article['news_site'] ?? '',
            style: const TextStyle(color: Colors.blue, fontSize: 16),
          ),
          const SizedBox(height: 20),
          Text(
            article['summary'] ?? '',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}