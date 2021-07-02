import 'package:flutter/material.dart';


class TestCard extends StatelessWidget {
final Function onPress;
TestCard({this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Color(0xFF1D1E33),
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(20),
        ),

      ),
    );
  }
}