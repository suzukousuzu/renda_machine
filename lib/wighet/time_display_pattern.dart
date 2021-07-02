import 'package:flutter/material.dart';
import 'package:renda_machine/constants.dart';

class TimeDisplayPattern extends StatelessWidget {
  TimeDisplayPattern(
      {this.tenTapNumber, this.sixtyTapNumber, this.endlessTapNumber});

  final String tenTapNumber;
  final String sixtyTapNumber;
  final String endlessTapNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        children: [
          TableRow(children: [
            Center(
                child: Text(
              "10s",
              style: kTopTextStyle,
            )),
            Center(
                child: Text(
              "60s",
              style: kTopTextStyle,
            )),
            Center(
                child: Text(
              "Endless",
              style: kTopTextStyle,
            ))
          ]),
          TableRow(children: [
            (() {
              if (tenTapNumber == "0") {
                return Center(
                    child: Text(
                  '---',
                  style: kTextStyle,
                ));
              } else {
                return Center(
                    child: Text(
                  tenTapNumber,
                  style: kTextStyle,
                ));
              }
            })(),
            (() {
              if (sixtyTapNumber == "0") {
                return Center(
                    child: Text(
                  '---',
                  style: kTextStyle,
                ));
              } else {
                return Center(
                    child: Text(
                  sixtyTapNumber,
                  style: kTextStyle,
                ));
              }
            })(),
            (() {
              if (endlessTapNumber == "0") {
                return Center(
                    child: Text(
                  '---',
                  style: kTextStyle,
                ));
              } else {
                return Center(
                    child: Text(
                  endlessTapNumber,
                  style: kTextStyle,
                ));
              }
            })(),
          ])
        ],
      ),
    );
  }
}
