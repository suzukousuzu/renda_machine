import 'package:flutter/material.dart';
import 'package:renda_machine/constants.dart';

class SelectedCard extends StatelessWidget {
  final Function onPress;
  final String text;
  final double width;
  final TextStyle kTestTextStyle;

  SelectedCard({this.onPress, this.text, this.width, this.kTestTextStyle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1D1E33),
          border: Border.all(color: Colors.red, width: width),
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Center(
          child: Text(
            text,
            style: kTestTextStyle,
          ),
        ),
      ),
    );
  }
}
