import 'package:flutter/material.dart';
import 'package:renda_machine/constants.dart';
import 'package:renda_machine/wighet/selected_card.dart';
import 'package:renda_machine/wighet/test_card.dart';
import 'package:provider/provider.dart';
import 'package:renda_machine/model/test_screen_model.dart';
import 'package:renda_machine/model/selected_data.dart';
import 'dart:async';
import 'package:renda_machine/entity/view_to_arguments.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestScreen extends StatelessWidget {
  TestScreen({this.selectedCard, this.endlessTapNumber, this.nickName,this.isUpdate});

  final Select selectedCard;
  int endlessTapNumber;
  String nickName;
  final bool isUpdate;


  @override
  Widget build(BuildContext context) {
    //Timer timer;
    return ChangeNotifierProvider(
      create: (context) => TestScreenModel()..getPrefItems(),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('images/blackhole (2).jpeg'),
              fit: BoxFit.cover,
            )),
            child: Consumer<TestScreenModel>(
              builder: (context, model, child) {
                //getPrefItems();
                return Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Text(
                      //  selectedCard == Select.tenSeconds ? model.tenDisplaySeconds :model.sixtyDisplaySeconds,
                      //   style: kTextStyle,
                      // ),
                      Expanded(
                        child: (() {
                          if (selectedCard == Select.tenSeconds) {
                            return Center(
                              child: Text(
                                model.tenDisplaySeconds,
                                style: kTestTextStyle,
                              ),
                            );
                          } else if (selectedCard == Select.sixtySeconds) {
                            return Center(
                              child: Text(
                                model.sixtyDisplaySeconds,
                                style: kTestTextStyle,
                              ),
                            );
                          } else {
                            return Center(
                              child: Text(
                                "No Limit",
                                style: kTestTextStyle,
                              ),
                            );
                          }
                        })(),
                      ),
                      Expanded(
                        child: SelectedCard (
                          onPress: () {
                            //timer.cancel();
                            if (model.isTimeUp ||
                                selectedCard == Select.tenSeconds ||
                                selectedCard == Select.sixtySeconds) {
                              Navigator.pop (
                                  context,
                                  ViewAToBArguments(
                                      tapNumber: model.tapNumber,
                                      NickName: nickName));

                              isUpdate ? model.updateScore(nickName, selectedCard) :  model.addScore(nickName,selectedCard);
                            } else if (selectedCard == Select.endless) {
                              Navigator.pop(
                                  context,
                                  ViewAToBArguments(
                                      endelessTapNumber: endlessTapNumber,
                                      NickName: nickName));
                              isUpdate ? model.updateScore(nickName, selectedCard) :  model.addScore(nickName,selectedCard);
                              model.setPrefItems();
                            } else {
                              Navigator.pop(context, "");
                            }
                            return Future.value(false);
                          },
                          width: kInActiveBorderWidth,
                          text: "QUIT",
                          kTestTextStyle: kTestTextStyle,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  // model.isStart
                  //     ? Container(
                  //         child: Text(
                  //         (model.tapNumber).toString(),
                  //         style: kTextStyle,
                  //       ))
                  //     : Container(
                  //         child: Text(
                  //         "Press any Button",
                  //         style: kTextStyle,
                  //       )),
                  (() {
                    if (selectedCard == Select.endless) {
                      return Container(
                          child: Text(
                        endlessTapNumber.toString(),
                        style: kTestTextStyle,
                      ));
                    } else if (model.isStart &&
                        (selectedCard == Select.tenSeconds ||
                            selectedCard == Select.sixtySeconds)) {
                      return Container(
                          child: Text(
                        (model.tapNumber).toString(),
                        style: kTestTextStyle,
                      ));
                    } else {
                      return Container(
                          child: Text(
                        "Press any Button",
                        style: kTextStyle,
                      ));
                    }
                  })(),
                  model.isStart || selectedCard == Select.endless
                      ? Container(child: Text(" "))
                      : Container(
                          child: Text(
                          "to start",
                          style: kTextStyle,
                        )),
                  model.isTimeUp
                      ? Container(
                          child: Text(
                          "TimeUp!!",
                          style: kTestTextStyle,
                        ))
                      : Container(child: Text(" ")),
                  model.isTimeUp
                      ? Text(" ")
                      : GridView.count(
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          childAspectRatio: (1 / 1.2),
                          children: List.generate(16, (index) {
                            return TestCard(onPress: () {
                              model.isStart
                                  ? null
                                  : model.repeatedTimer(selectedCard);
                              model.isTimeUp ? null : model.updateTapNumner();
                              if (selectedCard == Select.endless) {
                                model.isTimeUp
                                    ? null
                                    : endlessTapNumber =
                                        model.updateEndlessTapNumber(
                                            endlessTapNumber);
                              }
                            });
                          }))
                ]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
