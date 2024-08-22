import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'article_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('L\'immonde'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('news') // Nom de la collection dans Firestore
            .orderBy('timestamp',
                descending: true) // Trie par date de publication
            .get(), // Récupère les données
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des articles'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun article disponible'));
          } else {
            var articles = snapshot.data!.docs;

            return ListView(
              children: [
                _buildFeaturedArticle(
                    context, articles.first), // Article à la une
                SizedBox(height: 16.0),
                _buildOlderArticles(context,
                    articles.skip(1).toList()), // Articles plus anciens
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildFeaturedArticle(
      BuildContext context, QueryDocumentSnapshot article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticlePage(articleId: article.id),
          ),
        );
      },
      child: Column(
        children: [
          Image.network(
            article['imageUrl'],
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.black,
            child: Text(
              article['title'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOlderArticles(
      BuildContext context, List<QueryDocumentSnapshot> articles) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        var article = articles[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticlePage(articleId: article.id),
              ),
            );
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Image.network(
                  article['imageUrl'],
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    article['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
