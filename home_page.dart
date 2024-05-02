import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logintest/CreateChallengePage.dart';
import 'package:logintest/CreateQuizPage.dart';
import 'package:logintest/quiz_model.dart';
import 'create_post_page.dart';
import 'all_posts_page.dart';
import 'auth_service.dart';
import 'admin_user_model.dart';
import 'admin_highlight_widget.dart';
import 'PostCardWidget.dart';
import 'post_model.dart';
import 'quiz_details_page.dart';
import 'challenge_details_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  bool _isAdmin = false;
  List<AdminUserModel> _adminUsers = [];
  List<Quiz> _quizzes = [];
  List<Challenge> _challenges = [];

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
    _fetchAdminUsers();
    _fetchQuizzes();
    _fetchChallenges();
  }

  void _checkAdminStatus() async {
    bool isAdmin = await _authService.isUserAdmin();
    setState(() {
      _isAdmin = isAdmin;
    });
  }

  void _fetchAdminUsers() async {
    var adminSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('isAdmin', isEqualTo: true)
        .get();
    var admins = adminSnapshot.docs
        .map((doc) => AdminUserModel.fromSnapshot(doc))
        .toList();
    setState(() {
      _adminUsers = admins;
    });
  }

void _fetchQuizzes() async {
  try {
    var quizSnapshot = await FirebaseFirestore.instance.collection('quizzes').limit(5).get();
    var quizzes = quizSnapshot.docs.map((doc) => Quiz.fromSnapshot(doc)).toList();
    print('Quizzes fetched: ${quizzes.length}');  // Verifique quantos quizzes foram carregados
    setState(() {
      _quizzes = quizzes;
    });
  } catch (e) {
    print('Error fetching quizzes: $e');
  }
}


  void _fetchChallenges() async {
    var challengeSnapshot = await FirebaseFirestore.instance.collection('challenges').limit(5).get();
    var challenges = challengeSnapshot.docs.map((doc) => Challenge.fromSnapshot(doc)).toList();
    setState(() {
      _challenges = challenges;
    });
  }

  Widget _buildAdminHighlights() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _adminUsers.length,
        itemBuilder: (context, index) {
          return AdminHighlightWidget(adminUser: _adminUsers[index]);
        },
      ),
    );
  }

  Widget _buildHorizontalPostCards() {
    double cardHeight = MediaQuery.of(context).size.height * 0.25;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text("Conteúdos", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        ),
        Container(
          height: cardHeight,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('posts').orderBy('dateCreated', descending: true).limit(3).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar os posts'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('Ainda sem posts'));
              }
              var documents = snapshot.data!.docs;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: documents.length + 1,
                itemBuilder: (context, index) {
                  if (index == documents.length) {
                    return _buildViewAllCard(context);
                  } else {
                    BlogPost post = BlogPost.fromJson(documents[index].data() as Map<String, dynamic>);
                    return PostCardWidget(post: post);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFixedHorizontalCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text("Desafios e Quizzes", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        ),
        Container(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _quizzes.map((quiz) => _buildQuizCard(quiz)).toList() +
                     _challenges.map((challenge) => _buildChallengeCard(challenge)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildViewAllCard(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AllPostsPage())),
      child: Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Ver todos', 
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.bold, 
                fontSize: 18.0 // Ensure the colon is used and not a comma
              ),
            )
          ),
        ),
      ),
    );
  }


// Format remaining time with a visual metaphor and determine icon
TimeFormat _formatRemainingTime(DateTime endDate) {
  final now = DateTime.now();
  final difference = endDate.difference(now);
  IconData icon;
  if (difference.isNegative) {
    return TimeFormat('Quiz encerrado', Icons.cancel); // Using cancel icon for expired
  } else {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = twoDigits(difference.inDays);
    final hours = twoDigits(difference.inHours % 24); // Ensures correct hour display
    icon = difference.inDays < 1 ? Icons.new_releases : Icons.alarm; // Change icon based on urgency
    return TimeFormat('$days:$hours', icon); // Simplified format
  }
}
Widget _buildQuizCard(Quiz quiz) {
  TimeFormat timeInfo = _formatRemainingTime(quiz.endDate);
  return InkWell(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizDetailsPage(quizId: quiz.id),
      ),
    ),
    child: Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.withOpacity(0.9),
              Color.fromARGB(255, 31, 8, 72).withOpacity(0.7)
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              quiz.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(timeInfo.icon, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    timeInfo.time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizDetailsPage(quizId: quiz.id),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue, backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  "Ver mais",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



 Widget _buildChallengeCard(Challenge challenge) {
  return InkWell(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChallengeDetailsPage(challenge: challenge),
      ),
    ),
    child: Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.withOpacity(0.9), Colors.green.withOpacity(0.7)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              challenge.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Botão "Ver mais"
            Spacer(), // Espaço flexível para empurrar o botão para a parte inferior
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChallengeDetailsPage(challenge: challenge),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  "Ver mais",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildSingleCard(String title, String description, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(description, style: TextStyle(fontSize: 16.0, color: Colors.white70), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  @override
 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Bem vindo ao TECER'),
      actions: [
        if (_isAdmin)
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'post':
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostPage()));
                  break;
                case 'quiz':
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateQuizPage()));
                  break;
                case 'challenge':
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateChallengePage()));
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'post', child: Text('Criar Post')),
              const PopupMenuItem<String>(value: 'quiz', child: Text('Criar Quiz')),
              const PopupMenuItem<String>(value: 'challenge', child: Text('Criar Desafio')),
              //const PopupMenuItem<String>(value: 'Stories', child: Text('Criar Stories')),
            ],
          ),
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AllPostsPage())),
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Administradores",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          SizedBox(height: 8),
          _buildAdminHighlights(),
          SizedBox(height: 16),
          _buildHorizontalPostCards(),
          _buildFixedHorizontalCards(),
        ],
      ),
    ),
  );
}
}

class TimeFormat {
    final String time;
  final IconData icon;

  TimeFormat(this.time, this.icon);
}
