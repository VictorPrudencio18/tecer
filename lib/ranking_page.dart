import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(home: RankingPage()));
}

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rankings',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0, // Remove a sombra do AppBar
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false, // Impede que o botão de voltar seja exibido
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionHeader('Ranking Global'),
            SizedBox(height: 10),
            Expanded(child: buildGlobalRanking()),
            SizedBox(height: 20),
            _buildSectionHeader('Ranking por Comunidade'),
            SizedBox(height: 10),
            Expanded(child: buildCommunityRanking()), // Renomeado para buildCommunityRanking
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildGlobalRanking() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .orderBy('points', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        List<DocumentSnapshot> rankedUsers = snapshot.data!.docs;

        return ListView.builder(
          itemCount: rankedUsers.length,
          itemBuilder: (context, index) =>
              buildRankingTile(rankedUsers[index], index + 1),
        );
      },
    );
  }

  Widget buildCommunityRanking() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .orderBy('points', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        Map<String, List<DocumentSnapshot>> usersByCommunity = {};
        for (var doc in snapshot.data!.docs) {
          var data = doc.data() as Map<String, dynamic>?;
          if (data != null && data.containsKey('community')) {
            String community = data['community'];
            (usersByCommunity[community] ??= []).add(doc);
          }
        }

        return ListView.builder(
          itemCount: usersByCommunity.entries.length,
          itemBuilder: (context, index) {
            var entry = usersByCommunity.entries.elementAt(index);
            return buildCommunityRankingCard(entry.key, entry.value);
          },
        );
      },
    );
  }

  Widget buildCommunityRankingCard(String communityName, List<DocumentSnapshot> users) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              communityName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Column(
              children: users
                  .map((user) => buildCommunityUserTile(user))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCommunityUserTile(DocumentSnapshot user) {
    var data = user.data() as Map<String, dynamic>?;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.deepPurple,
        child: Text(data != null ? data['name'][0] : '',
            style: TextStyle(color: Colors.white)),
      ),
      title: Text(data != null ? data['name'] : 'Desconhecido'),
      trailing: Chip(
        label: Text('${data != null ? data['points'] : 0} pontos'),
        backgroundColor: Colors.amber,
      ),
    );
  }

  Widget buildRankingTile(DocumentSnapshot user, int rank) {
    var data = user.data() as Map<String, dynamic>?;
    Color rankColor = rank == 1
        ? Colors.orange
        : rank == 2
            ? Colors.grey
            : rank == 3
                ? Colors.brown
                : Colors.grey;

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(data != null ? data['name'] : 'Desconhecido'),
        subtitle: Text('Pontos: ${data != null ? data['points'] : 0}'),
        trailing: Chip(
          label: Text('#$rank'),
          backgroundColor: rankColor,
        ),
      ),
    );
  }
}
