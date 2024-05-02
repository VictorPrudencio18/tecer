import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'quiz_details_page.dart'; // Certifique-se de que este arquivo existe
import 'challenge_details_page.dart'; // Certifique-se de que este arquivo existe
import 'post_details_page.dart'; // Certifique-se de que este arquivo existe
import 'edit_challenge_page.dart'; // Substitua pelo caminho correto da sua página de edição de desafios

class AdminManagementPage extends StatefulWidget {
  @override
  _AdminManagementPageState createState() => _AdminManagementPageState();
}

class _AdminManagementPageState extends State<AdminManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciamento de Conteúdo'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildContentSection('Quizzes', 'quizzes', context),
            buildContentSection('Desafios', 'challenges', context),
            buildContentSection('Posts', 'posts', context),
          ],
        ),
      ),
    );
  }

  Widget buildContentSection(String title, String collection, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection(collection).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Erro ao carregar $title.');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var document = snapshot.data!.docs[index];
                return buildItemCard(document, context, title);
              },
            );
          },
        ),
      ],
    );
  }

  Widget buildItemCard(DocumentSnapshot document, BuildContext context, String title) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    String startDateStr = getFormattedDate(data['startDate']);
    String endDateStr = getFormattedDate(data['endDate']);

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        title: Text(data['title'], style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(data['description'] ?? 'Nenhuma descrição disponível', overflow: TextOverflow.ellipsis),
            if (title == 'Quizzes') ...[
              SizedBox(height: 4),
              Text('Início: $startDateStr', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              Text('Fim: $endDateStr', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ],
        ),
        trailing: buildTrailingIcons(title, document, context),
        isThreeLine: title == 'Quizzes',
        onTap: () => navigateToDetailPage(document.id, title, context),
      ),
    );
  }

  // Helper method to get formatted date string
  String getFormattedDate(dynamic dateField) {
    if (dateField is Timestamp) {
      DateTime date = dateField.toDate();
      return DateFormat('dd/MM/yyyy').format(date);
    } else {
      return 'Indefinido';
    }
  }

  // Helper method for conditional detail page navigation based on title
  void navigateToDetailPage(String documentId, String title, BuildContext context) {
    if (title == 'Quizzes') {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuizDetailsPage(quizId: documentId)));
    } else if (title == 'Desafios') {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        var challenge = null;
        return ChallengeDetailsPage(challengeId: documentId, challenge: challenge,);
      }));
    } else if (title == 'Posts') {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        var post = null;
        return PostDetailsPage(postId: documentId, post: post,);
      }));
    }
  }

  // Helper method to build trailing icons for different sections
  Widget buildTrailingIcons(String title, DocumentSnapshot document, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (title == 'Quizzes') IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmDelete(context, document, 'Quizzes'),
        ),
        if (title == 'Desafios') ...buildChallengeCardTrailingButtons(document, context),
        if (title == 'Posts') IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmDelete(context, document, 'Posts'),
        ),
      ],
    );
  }

  // Build trailing buttons for challenge card
  List<Widget> buildChallengeCardTrailingButtons(DocumentSnapshot document, BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.edit, color: Colors.orange),
        onPressed: () => navigateToEditChallengePage(document.id, context),
      ),
      IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () => _confirmDelete(context, document, 'Desafios'),
      ),
    ];
  }

  // Method to navigate to edit challenge page
  void navigateToEditChallengePage(String challengeId, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditChallengePage(challengeId: challengeId), // Make sure this page is created
    ));
  }

  // Method to confirm deletion
  void _confirmDelete(BuildContext context, DocumentSnapshot document, String collection) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Você tem certeza que deseja apagar este item?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Apagar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                document.reference.delete().then((_) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$collection apagado com sucesso.')),
                  );
                }).catchError((error) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao apagar o $collection: $error')),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }
}
