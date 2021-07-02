import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renda_machine/entity/score.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:renda_machine/wighet/scorebunddle.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Select { tenSeconds, sixtySeconds, endless }

final _firestore = FirebaseFirestore.instance;

class SelectTimes extends ChangeNotifier {
  List<Score> names = [];
  List<Score> scores = [];
  Select selectCard = Select.tenSeconds;
  String tenTapNumber = "0";
  String sixtyTapNumber = "0";
  String endlessTapNumber = "0";
  List<ScoreBunddle> scoreBubbles = [];
  int indexNumber = 0;
  String nickName;
  bool buttonDisplay = true;

  void selectTenNumber() {
    selectCard = Select.tenSeconds;
    notifyListeners();
  }

  void selectSixtySeconds() {
    selectCard = Select.sixtySeconds;
    notifyListeners();
  }

  void selectEndless() {
    selectCard = Select.endless;
    notifyListeners();
  }

  void updateResult(String result) {
    if (selectCard == Select.tenSeconds) {
      if (int.parse(result) > int.parse(tenTapNumber)) {
        tenTapNumber = result;
      }
    } else if (selectCard == Select.sixtySeconds) {
      if (int.parse(result) > int.parse(sixtyTapNumber)) {
        sixtyTapNumber = result;
      }
    } else {
      if (int.parse(result) > int.parse(endlessTapNumber)) {
        endlessTapNumber = result;
      }
    }
    notifyListeners();
  }
  void updateDisplay() {
    this.nickName = nickName;
    if( this.nickName == "") {
      buttonDisplay = false;
    } else {
      buttonDisplay = true;
    }
    notifyListeners();

    }




  // void fetchName() async{
  //   final score = await FirebaseFirestore.instance.collection('Score').get();
  //   final docs = score.docs;
  //   for(var score in docs) {
  //     print(score.data());
  //   }
  // final name = docs.docs.map((doc) => Score(name:doc['name'])).toList();
  // this.name= name;
  //   final docs = message.docs;
  //   for(var message in docs) {
  //     print(message.data());
  //   }

  // Future<QuerySnapshot> fetchName() async {
  //   final score = await _firestore.collection('scores').orderBy('score',descending: true).get();
  //   final docs = score.docs;
  //   for (var scores in docs) {
  //     final nickName = await scores.data()['name'];
  //     final tapScore = await scores.data()['score'];
  //     if(nickName != "") {
  //       indexNumber += 1;
  //       final scoreBunddle =  ScoreBunddle(nickName: nickName,score: tapScore,indexNumber: indexNumber,);
  //       scoreBubbles.add(scoreBunddle);
  //     }
  //   }
  //
  //   // final names = docs.map((doc) => Score(name: doc['name'])).toList();
  //   // final scores = docs.map((doc) => Score(score: doc['score'])).toList();
  //   // this.names = names;
  //   // this.scores = scores;
  //
  //   notifyListeners();
  // }

  void fetchName() {
    scoreBubbles = [];
    Stream<QuerySnapshot> snapshots;
    if (selectCard == Select.tenSeconds) {
      snapshots = _firestore
          .collection('scores')
          .orderBy('score', descending: true)
          .snapshots();
    }
    else if (selectCard == Select.sixtySeconds) {
      snapshots = _firestore
          .collection('sixtyScores')
          .orderBy('score', descending: true)
          .snapshots();
    }
    else if (selectCard == Select.endless) {
      snapshots = _firestore
          .collection('endlessScores')
          .orderBy('score', descending: true)
          .snapshots();
    }

    snapshots.listen((snapshot) {
      indexNumber = 0;
      final docs = snapshot.docs;
      for (var scores in docs) {
        final nickName = scores.data()['name'];
        final tapScore = scores.data()['score'];
        print(nickName);
        if(nickName != null) {
          if (nickName != "") {
            if(indexNumber <= 4) {
              indexNumber += 1;
              print(indexNumber);
              final scoreBunddle = ScoreBunddle(
                nickName: nickName,
                score: tapScore,
                indexNumber: indexNumber,
              );
              scoreBubbles.add(scoreBunddle);
            }
          }
        }
      }
    });
    notifyListeners();
  }

  Future <void> setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter',  int.parse(endlessTapNumber));
  }

  Future<void> getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    endlessTapNumber = (prefs.getInt('counter') ?? 0).toString();
  }

  Future<void> setName(String nickName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', nickName);
    notifyListeners();
  }

  Future<void> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.nickName = prefs.getString('name') ?? '';
    notifyListeners();
  }


}
// }