import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Future<void> tambahNotifAwal() async {
    final data = await FirebaseFirestore.instance.collection('notifications').get();

    if (data.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('notifications').add({
        'title': 'Headline News',
        'body': 'Berita luar angkasa terbaru sudah tersedia',
        'createdAt': Timestamp.now(),
      });

      await FirebaseFirestore.instance.collection('notifications').add({
        'title': 'Update Artikel',
        'body': 'Artikel baru berhasil dimuat',
        'createdAt': Timestamp.now(),
      });

      await FirebaseFirestore.instance.collection('notifications').add({
        'title': 'SpaceNews Core',
        'body': 'Jangan lupa baca headline hari ini',
        'createdAt': Timestamp.now(),
      });
    }
  }

  @override
  void initState() {
    super.initState();
    tambahNotifAwal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Terjadi error saat mengambil notifikasi'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('Belum ada notifikasi'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: const Icon(Icons.notifications, color: Colors.blue),
                title: Text(data['title'] ?? ''),
                subtitle: Text(data['body'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}