import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class NonSmokerGoalsPage extends StatefulWidget {
  @override
  _NonSmokerGoalsPageState createState() => _NonSmokerGoalsPageState();
}

class _NonSmokerGoalsPageState extends State<NonSmokerGoalsPage> {
  Map<String, dynamic>? userData;
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _customGoalController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rewardController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  int? _editingIndex;

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
        'healthGoal': goal,
        'currentStreak': 0,
      }).then((_) {
        _fetchUserData();
      });
    }
  }

  void _saveCustomGoal() {
    if (_customGoalController.text.isNotEmpty && _descriptionController.text.isNotEmpty && _rewardController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'customGoals': FieldValue.arrayUnion([{
          'goal': _customGoalController.text,
          'progress': 0,
          'description': _descriptionController.text,
          'reward': _rewardController.text,
          'date': _selectedDate != null ? _selectedDate!.toIso8601String() : null,
        }])
      }).then((_) {
        _customGoalController.clear();
        _descriptionController.clear();
        _rewardController.clear();
        _dateController.clear();
        _selectedDate = null;
        _fetchUserData();
      });
    }
  }

  void _saveEditedGoal() {
    if (_editingIndex != null && _customGoalController.text.isNotEmpty && _descriptionController.text.isNotEmpty && _rewardController.text.isNotEmpty) {
      List<dynamic> customGoals = List.from(userData!['customGoals']);
      customGoals[_editingIndex!] = {
        'goal': _customGoalController.text,
        'progress': customGoals[_editingIndex!]['progress'],
        'description': _descriptionController.text,
        'reward': _rewardController.text,
        'date': _selectedDate != null ? _selectedDate!.toIso8601String() : customGoals[_editingIndex!]['date'],
      };
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'customGoals': customGoals,
      }).then((_) {
        _customGoalController.clear();
        _descriptionController.clear();
        _rewardController.clear();
        _dateController.clear();
        _selectedDate = null;
        _editingIndex = null;
        _fetchUserData();
      });
    }
  }

  void _editCustomGoal(int index) {
    setState(() {
      _editingIndex = index;
      _customGoalController.text = userData!['customGoals'][index]['goal'];
      _descriptionController.text = userData!['customGoals'][index]['description'];
      _rewardController.text = userData!['customGoals'][index]['reward'];
      if (userData!['customGoals'][index]['date'] != null) {
        _selectedDate = DateTime.parse(userData!['customGoals'][index]['date']);
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      }
    });
    _showEditDialog();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Meta Personalizada'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _customGoalController,
                  decoration: InputDecoration(
                    labelText: 'Defina uma meta personalizada',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(Icons.edit, color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descrição da meta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(Icons.description, color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _rewardController,
                  decoration: InputDecoration(
                    labelText: 'Prêmio ao concluir a meta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(Icons.card_giftcard, color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Data da meta (opcional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.black),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _saveEditedGoal();
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _updateProgress(int index, int delta) {
    if (userData != null && userData!['customGoals'] != null) {
      List<dynamic> customGoals = List.from(userData!['customGoals']);
      if (customGoals[index] is Map<String, dynamic>) {
        customGoals[index]['progress'] += delta;
        if (customGoals[index]['progress'] < 0) {
          customGoals[index]['progress'] = 0;
        }
        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          'customGoals': customGoals,
        }).then((_) {
          _fetchUserData();
        });
      }
    }
  }

  void _updateGoalProgress(int delta) {
    if (userData != null) {
      int currentStreak = userData!['currentStreak'] ?? 0;
      int healthGoal = userData!['healthGoal'] ?? 1;
      currentStreak += delta;
      if (currentStreak < 0) {
        currentStreak = 0;
      }
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'currentStreak': currentStreak,
      }).then((_) {
        _fetchUserData();
      });
    }
  }

  void _removeCustomGoal(int index) {
    if (userData != null && userData!['customGoals'] != null) {
      List<dynamic> customGoals = List.from(userData!['customGoals']);
      customGoals.removeAt(index);
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'customGoals': customGoals,
      }).then((_) {
        _fetchUserData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/home');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Metas de Saúde'),
          backgroundColor: Colors.deepPurple,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(255, 255, 255, 255),
                const Color.fromARGB(255, 240, 240, 240),
              ],
            ),
          ),
          child: userData == null
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Parabéns por não fumar, ${userData!['name']}!',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(height: 20),
                      Text(
                        'Metas de Saúde',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _goalController,
                          decoration: InputDecoration(
                            labelText: 'Defina sua meta de dias para um novo hábito saudável',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _saveGoal,
                            child: Text('Salvar Meta', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _updateGoalProgress(1),
                            child: Text('+', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _updateGoalProgress(-1),
                            child: Text('-', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      LinearProgressIndicator(
                        value: (userData!['currentStreak'] ?? 0) / (userData!['healthGoal'] ?? 1),
                        backgroundColor: Colors.grey[200],
                        minHeight: 20,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'Progresso: ${userData!['currentStreak']} de ${userData!['healthGoal']} dias',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Adicionar Nova Meta Personalizada',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Form(
                        key: GlobalKey<FormState>(),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _customGoalController,
                              decoration: InputDecoration(
                                labelText: 'Defina uma meta personalizada',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: Icon(Icons.edit, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, insira um valor';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Descrição da meta',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: Icon(Icons.description, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, insira uma descrição';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _rewardController,
                              decoration: InputDecoration(
                                labelText: 'Prêmio ao concluir a meta',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: Icon(Icons.card_giftcard, color: Colors.black),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, insira um prêmio';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _dateController,
                              decoration: InputDecoration(
                                labelText: 'Data da meta (opcional)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: Icon(Icons.calendar_today, color: Colors.black),
                              ),
                              readOnly: true,
                              onTap: () => _selectDate(context),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _editingIndex != null ? _saveEditedGoal : _saveCustomGoal,
                          child: Text(
                            _editingIndex != null ? 'Salvar Edição' : 'Salvar Meta Personalizada',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Metas Personalizadas',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      _buildCustomGoals(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCustomGoals() {
    if (userData == null || userData!['customGoals'] == null) {
      return Container();
    }
    List<Map<String, dynamic>> customGoals = List<Map<String, dynamic>>.from(userData!['customGoals']);
    return Column(
      children: customGoals.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> goal = entry.value;
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(goal['goal'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 10),
                Text('Descrição: ${goal['description']}', style: TextStyle(color: Colors.black)),
                SizedBox(height: 5),
                Text('Prêmio: ${goal['reward']}', style: TextStyle(color: Colors.black)),
                if (goal['date'] != null) ...[
                  SizedBox(height: 5),
                  Text('Data: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(goal['date']))}', style: TextStyle(color: Colors.black)),
                ],
                SizedBox(height: 10),
                LinearProgressIndicator(
                  value: goal['progress'] / (userData!['healthGoal'] ?? 1),
                  backgroundColor: Colors.grey[200],
                  minHeight: 20,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Progresso: ${goal['progress']}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, color: Colors.red),
                      onPressed: () => _updateProgress(index, -1),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.green),
                      onPressed: () => _updateProgress(index, 1),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _editCustomGoal(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.grey),
                      onPressed: () => _removeCustomGoal(index),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
