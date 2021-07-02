import 'package:flutter/material.dart';
import 'package:renda_machine/constants.dart';

class ScoreBunddle extends StatelessWidget {
  ScoreBunddle({this.nickName, this.score, this.indexNumber});

  final String nickName;
  final int score;
  final int indexNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          indexNumber.toString(),
          style: leadersBoardText,
        ),
        Text(
          nickName,
          style: leadersBoardText,
        ),
        Text(
          score.toString(),
          style: leadersBoardText,
        )
      ],
    );
  }
}
