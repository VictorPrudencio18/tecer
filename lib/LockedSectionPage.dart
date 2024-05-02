import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LockedSectionPage extends StatefulWidget {
  @override
  _LockedSectionPageState createState() => _LockedSectionPageState();
}

class _LockedSectionPageState extends State<LockedSectionPage> {
  Map<String, dynamic>? userData;
  final TextEditingController _goalController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          userData = documentSnapshot.data() as Map<String, dynamic>?;
        });
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void _saveGoal() {
    if (_formKey.currentState!.validate()) {
      int goal = int.tryParse(_goalController.text) ?? 0;
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'quitGoal': goal,
        'currentStreak': 0,
      }).then((_) {
        _fetchUserData();
      });
    }
  }

  void _updateProgress() {
    if (userData != null) {
      int currentStreak = (userData!['currentStreak'] ?? 0) + 1;
      int quitGoal = userData!['quitGoal'] ?? 1;
      if (currentStreak <= quitGoal) {
        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          'currentStreak': currentStreak,
        }).then((_) {
          _fetchUserData();
          if (currentStreak >= quitGoal) {
            // O usuário atingiu a meta, você pode adicionar ações aqui, como mostrar uma mensagem de parabéns.
          }
        });
      } else {
        // O usuário já atingiu a meta, você pode adicionar feedbacks visuais aqui.
      }
    }
  }

  void _showPreventionTips() {
    // Lógica para exibir dicas de prevenção contra o fumo
    // Você pode implementar a lógica para mostrar dicas de prevenção contra o tabagismo aqui.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seção Personalizada',
          style: TextStyle(color: Colors.white), // Mudando a cor do texto do AppBar para branco
        ),
        backgroundColor: const Color.fromARGB(255, 82, 34, 255),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 255, 255, 255), // Cor de fundo mais clara
              const Color.fromARGB(255, 240, 240, 240), // Cor de fundo mais escura
            ],
          ),
        ),
        child: userData == null ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Bem-vindo, ${userData!['name']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _goalController,
                  decoration: InputDecoration(
                    labelText: 'Defina sua meta de dias sem fumar',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(Icons.flag, color: Colors.black),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um valor';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveGoal,
                  child: Text('Salvar Meta', style: TextStyle(color: Colors.white)), // Mudando a cor do texto do botão para branco
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              LinearProgressIndicator(
                value: (userData!['currentStreak'] ?? 0) / (userData!['quitGoal'] ?? 1),
                backgroundColor: Colors.grey[200],
                minHeight: 20,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'Progresso: ${userData!['currentStreak']} de ${userData!['quitGoal']} dias',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateProgress,
                  child: Text('Atualizar Progresso', style: TextStyle(color: Colors.white)), // Mudando a cor do texto do botão para branco
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 94, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Dicas de Prevenção',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 10),
              // Lista de cards de exemplos para prevenção
              _buildPreventionCards(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreventionCards() {
    return Column(
      children: [
        _preventionCard(
          title: 'Meditação',
          subtitle: 'Praticar meditação pode ajudar a reduzir o estresse e a ansiedade, facilitando o processo de parar de fumar.',
          icon: Icons.self_improvement,
        ),
        SizedBox(height: 20),
        _preventionCard(
          title: 'Apoio Psicológico',
          subtitle: 'Buscar apoio de um psicólogo pode ser fundamental para lidar com os desafios emocionais ao parar de fumar.',
          icon: Icons.psychology,
        ),
        SizedBox(height: 20),
        _preventionCard(
          title: 'Prática de Esportes',
          subtitle: 'Praticar esportes regularmente pode ajudar a manter a mente ocupada e reduzir o desejo de fumar.',
          icon: Icons.sports_soccer,
        ),
      ],
    );
  }

  Widget _preventionCard({required String title, required String subtitle, required IconData icon}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Adicionando curvas nos cards
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 5),
            Text(subtitle, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}

