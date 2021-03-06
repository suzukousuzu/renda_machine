import 'dart:math';

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
  bool isUpdate = false;

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
        notifyListeners();
      }
    } else if (selectCard == Select.sixtySeconds) {
      if (int.parse(result) > int.parse(sixtyTapNumber)) {
        sixtyTapNumber = result;
        notifyListeners();
      }
    } else {
      if (int.parse(result) > int.parse(endlessTapNumber)) {
        endlessTapNumber = result;
        notifyListeners();
      }
    }
  }

  void updateDisplay() {
    this.nickName = nickName;
    if (this.nickName == "") {
      buttonDisplay = false;
    } else {
      buttonDisplay = true;
    }
    notifyListeners();
  }

  void fetchName() {
    scoreBubbles = [];
    Stream<QuerySnapshot> snapshots;
    if (selectCard == Select.tenSeconds) {
      snapshots = _firestore
          .collection('scores')
          .orderBy('score', descending: true)
          .snapshots();
    } else if (selectCard == Select.sixtySeconds) {
      snapshots = _firestore
          .collection('sixtyScores')
          .orderBy('score', descending: true)
          .snapshots();
    } else if (selectCard == Select.endless) {
      snapshots = _firestore
          .collection('endlessScores')
          .orderBy('score', descending: true)
          .snapshots();
    }

    snapshots.listen((snapshot) {
      isUpdate = false;
      indexNumber = 0;
      final docs = snapshot.docs;
      for (var scores in docs) {
        final nickName = scores.data()['name'];
        final tapScore = scores.data()['score'];
        if(this.nickName == nickName) {
          isUpdate = true;
        }
        if (nickName != null) {
          if (nickName != "") {
            if (indexNumber <= 4) {
              indexNumber += 1;
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

  void fetchScore() {
    Stream<QuerySnapshot> tenSnapshots;
    Stream<QuerySnapshot> sixtySnapshots;
    Stream<QuerySnapshot> endlessSnapshots;

    tenSnapshots = _firestore
        .collection('scores')
        .orderBy('score', descending: true)
        .snapshots();

    tenSnapshots.listen((snapshot) {
      tenTapNumber = "0";
      final docs = snapshot.docs;
      for (var scores in docs) {
        final nickName = scores.data()['name'];
        if (this.nickName == nickName) {

          int kTenTapNumber = scores.data()['score'];
          if (kTenTapNumber > int.parse(tenTapNumber)) {
            tenTapNumber = kTenTapNumber.toString();
            notifyListeners();

          }
        }
      }
    });

    sixtySnapshots = _firestore
        .collection('sixtyScores')
        .orderBy('score', descending: true)
        .snapshots();

    sixtySnapshots.listen((snapshot) {
      sixtyTapNumber = "0";
      final docs = snapshot.docs;
      for (var scores in docs) {
        final nickName = scores.data()['name'];
        if (this.nickName == nickName) {
          int kSixtyTapNumber = scores.data()['score'];
          if (kSixtyTapNumber > int.parse(sixtyTapNumber)) {
            sixtyTapNumber = kSixtyTapNumber.toString();
            notifyListeners();
          }
        }
      }
    });

    endlessSnapshots = _firestore
        .collection('endlessScores')
        .orderBy('score', descending: true)
        .snapshots();

    endlessSnapshots.listen((snapshot) {
      endlessTapNumber = "0";
      final docs = snapshot.docs;
      for (var scores in docs) {
        final nickName = scores.data()['name'];
        if (this.nickName == nickName) {
          int kEndlessTapNumber = scores.data()['score'];
          if (kEndlessTapNumber > int.parse(endlessTapNumber)) {
            endlessTapNumber = kEndlessTapNumber.toString();
            notifyListeners();
          }

        }
      }
    });
  }

  void updateNickName(String name) {
    this.nickName = name;
    notifyListeners();
  }

  // Future<void> setPrefItems() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setInt('counter', int.parse(endlessTapNumber));
  // }
  //
  // Future<void> getPrefItems() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   endlessTapNumber = (prefs.getInt('counter') ?? 0).toString();
  // }

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
