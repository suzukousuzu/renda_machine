import 'package:flutter/material.dart';
import 'dart:async';
import 'package:renda_machine/model/selected_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 追記
import 'package:cloud_firestore/cloud_firestore.dart';

class TestScreenModel extends ChangeNotifier {
  int tapNumber = -1;

  int kEndlessTapNumber;
  double tenRemainingSeconds = 00.00;
  String tenDisplaySeconds = "00.00";
  double sixtyRemainingSeconds = 00.00;
  String sixtyDisplaySeconds = "00.00";
  bool isTimeUp = false;
  bool isStart = false;
  bool isEndless = false;
  final _firestore = FirebaseFirestore.instance;
  String nickName;


  void updateTapNumner() {
    // if (tapNumber == 0) {
    //   repeatedTimer();
    // }
    tapNumber += 1;
    notifyListeners();
  }

  int updateEndlessTapNumber(int endlessTapNumber) {
    endlessTapNumber += 1;
    kEndlessTapNumber =  endlessTapNumber;
    notifyListeners();
    return kEndlessTapNumber;
  }

  Future<void> repeatedTimer(Select select) async {
    isStart = true;
    if (select == Select.tenSeconds) {
      Timer.periodic(const Duration(milliseconds: 10), _onTenTimer);
    } else if (select == Select.sixtySeconds) {
      Timer.periodic(const Duration(milliseconds: 10), _onSixtyTimer);
    } else if (select == Select.endless) {
      isEndless = true;
    }
    notifyListeners();
  }

  void _onTenTimer(Timer timer) {
    tenRemainingSeconds += 0.01;
    tenDisplaySeconds = tenRemainingSeconds.toStringAsFixed(2);
    if (tenRemainingSeconds > 10) {
      timer.cancel();
      tenDisplaySeconds = "10.00";
      isTimeUp = true;
    }
    notifyListeners();
  }

  void _onSixtyTimer(Timer timer) {
    sixtyRemainingSeconds += 0.01;
    sixtyDisplaySeconds = sixtyRemainingSeconds.toStringAsFixed(2);
    if (sixtyRemainingSeconds > 60) {
      timer.cancel();
      sixtyDisplaySeconds = "60.00";
      isTimeUp = true;
    }
    notifyListeners();
  }

  void addScore(String nickName, Select select)  async{
    if (select == Select.tenSeconds) {
       await FirebaseFirestore.instance
          .collection('scores')
          .add({'name': nickName, 'score': tapNumber});
    } else if (select == Select.sixtySeconds) {
       await FirebaseFirestore.instance
          .collection('sixtyScores')
          .add({'name': nickName, 'score': tapNumber});
    } else if (select == Select.endless) {
       await FirebaseFirestore.instance
          .collection('endlessScores')
          .add({'name': nickName, 'score': kEndlessTapNumber});
    }

  }

  Future <void> setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter',  kEndlessTapNumber);
  }

  Future<void> getPrefItems() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      kEndlessTapNumber = (prefs.getInt('counter') ?? 0);

  }


  void updateScore(String name, Select select) {
    Stream<QuerySnapshot> tenSeconds;
    Stream<QuerySnapshot> sixtySeconds;
    Stream<QuerySnapshot> endless;

    if (select == Select.tenSeconds) {
      tenSeconds = _firestore
          .collection('scores')
          .orderBy('score', descending: true)
          .snapshots();

      tenSeconds.listen((snapshot) {
        final docs = snapshot.docs;
        for (var scores in docs) {
          final nickName = scores.data()['name'];
          final score = scores.data()['score'];
          final documentId = scores.id;
          if (nickName == name) {
            if (score < tapNumber) {
              FirebaseFirestore.instance
                  .collection('scores')
                  .doc(documentId)
                  .update({"score": tapNumber});

            }
          }
        }
      });
    }

    if (select == Select.sixtySeconds) {
      sixtySeconds = _firestore
          .collection('sixtyScores')
          .orderBy('score', descending: true)
          .snapshots();

      sixtySeconds.listen((snapshot) {
        final docs = snapshot.docs;
        for (var scores in docs) {
          final nickName = scores.data()['name'];
          final score = scores.data()['score'];
          final documentId = scores.id;
          if (nickName == name) {
            if (score < tapNumber) {
              FirebaseFirestore.instance
                  .collection('sixtyScores')
                  .doc(documentId)
                  .update({"score": tapNumber});
            }
          }
        }
      });
    }

    if (select == Select.endless) {
      endless = _firestore
          .collection('endlessScores')
          .orderBy('score', descending: true)
          .snapshots();

      endless.listen((snapshot) {
        final docs = snapshot.docs;
        for (var scores in docs) {
          final nickName = scores.data()['name'];
          final score = scores.data()['score'];
          final documentId = scores.id;
          if (nickName == name) {
            if (score < kEndlessTapNumber) {
              FirebaseFirestore.instance
                  .collection('endlessScores')
                  .doc(documentId)
                  .update({"score": kEndlessTapNumber});
            }
          }
        }
      });
    }
    notifyListeners();
  }


//   void fetchScore(Select select, String nickName) {
//     Stream<QuerySnapshot> snapshots;
//     if (select == Select.endless) {
//       snapshots = _firestore
//           .collection('endlessScores')
//           .where('name', isEqualTo: nickName)
//           .snapshots();
//       snapshots.listen(
//             (snapshot) {
//           final docs = snapshot.docs;
//           for (var scores in docs) {
//             kEndlessTapNumber = scores.data()['score'];
//             print(kEndlessTapNumber);
//           }
//         },
//       );
//     }else {
//       kEndlessTapNumber = 0;
//     }
//     notifyListeners();
//   }
 }
//
// (timer) {
// remainingSeconds -= 1;
// notifyListeners();
// if (remainingSeconds <= 0) {
// timer.cancel();
// notifyListeners();
// }
// }
