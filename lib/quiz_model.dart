
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Question {
  String questionText;
  List<String> options;
  int correctOptionIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionText: map['questionText'],
      options: List<String>.from(map['options']),
      correctOptionIndex: map['correctOptionIndex'],
    );
  }
}

class Quiz {
  String id;
  String title;
  List<Question> questions;
  DateTime startDate;  // Adicione esta linha
  DateTime endDate;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
    required this.startDate,  // Adicione este parâmetro
    required this.endDate,
  });

  static Quiz fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Quiz(
      id: snapshot.id,
      title: data['title'],
      questions: List<Question>.from(data['questions'].map((q) => Question.fromMap(q))),
      startDate: DateTime.fromMillisecondsSinceEpoch(data['startDate']),  // Converta timestamp para DateTime
      endDate: DateTime.fromMillisecondsSinceEpoch(data['endDate']),
    );
  }
}



class QuizCard extends StatelessWidget {
  final Quiz quiz;

  const QuizCard({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
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
            colors: [const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8), const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quiz.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Finaliza em: ${DateFormat('dd/MM/yyyy').format(quiz.endDate)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              ...quiz.questions.map((question) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    question.questionText,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
