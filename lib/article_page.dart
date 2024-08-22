import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticlePage extends StatelessWidget {
  final String articleId;

  ArticlePage({required this.articleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('L\'immonde'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('news').doc(articleId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement de l\'article'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('L\'article n\'existe pas'));
          } else {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            var title = data['title'];
            var imageUrl = data['imageUrl'];
            var chap1 = data['chap1'] ?? '';
            var chap2 = data['chap2'] ?? '';
            var chap3 = data['chap3'] ?? '';
            var chap4 = data['chap4'] ?? '';
            var chap5 = data['chap5'] ?? '';
            var chap6 = data['chap6'] ?? '';

            return ListView(
              children: [
                Image.network(imageUrl, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                _buildChapter(context, "Chapitre 1", chap1),
                _buildChapter(context, "Chapitre 2", chap2),
                _buildChapter(context, "Chapitre 3", chap3),
                _buildChapter(context, "Chapitre 4", chap4),
                _buildChapter(context, "Chapitre 5", chap5),
                _buildChapter(context, "Chapitre 6", chap6),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildChapter(
      BuildContext context, String chapterTitle, String content) {
    if (content.isEmpty) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chapterTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            content,
            style: TextStyle(
              fontSize: 18,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
