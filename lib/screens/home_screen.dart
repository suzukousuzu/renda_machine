import 'package:flutter/material.dart';
import 'package:renda_machine/wighet/time_display_pattern.dart';
import 'package:renda_machine/constants.dart';
import 'package:renda_machine/wighet/selected_card.dart';
import 'package:provider/provider.dart';
import 'package:renda_machine/model/selected_data.dart';
import 'package:renda_machine/screens/test_screen.dart';
import 'dart:async';
import 'package:renda_machine/entity/view_to_arguments.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  ViewAToBArguments result;
  String nickName;
  String startText = "---";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectTimes()
        ..fetchName()
        ..getName(),
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("images/blackhole (2).jpeg"),
            fit: BoxFit.cover,
          )),
          child: Consumer<SelectTimes>(builder: (context, model, child) {
            model.fetchScore();
            final _controller = TextEditingController.fromValue(
              TextEditingValue(
                text: model.nickName ?? "",
                selection: TextSelection.collapsed(
                    offset: model.nickName?.length ?? 0),
              ),
            );
            //model.getPrefItems();
            nickName = model.nickName;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TimeDisplayPattern(
                  tenTapNumber: model.tenTapNumber,
                  sixtyTapNumber: model.sixtyTapNumber,
                  endlessTapNumber: model.endlessTapNumber,

                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: Text(
                    "Renda ",
                    style: KTitleTextStyle,
                  ),
                ),
                Center(
                  child: Text(
                    "Machine",
                    style: KTitleTextStyle,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: 10.0, left: 60.0, right: 60.0, bottom: 30.0),
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      nickName = value;
                      model.updateNickName(nickName);
                      model.updateDisplay();
                      model.fetchScore();
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter NickName',
                      labelStyle: TextStyle(color: Colors.black),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        (() {
                          if (model.buttonDisplay == true) {
                            return Expanded(
                              child: Container(
                                width: 100.0,
                                child: SelectedCard(
                                  onPress: () {
                                    model.selectTenNumber();
                                    model.fetchName();
                                  },
                                  width: model.selectCard == Select.tenSeconds
                                      ? kActiveBorderWidth
                                      : kInActiveBorderWidth,
                                  text: "10s",
                                  kTestTextStyle: kTextStyle,
                                ),
                              ),
                            );
                          } else {
                            return Expanded(child: Text(''));
                          }
                        })(),
                        SizedBox(
                          width: 10.0,
                        ),
                        (() {
                          if (model.buttonDisplay == true) {
                            return Expanded(
                              child: Container(
                                width: 100.0,
                                child: SelectedCard(
                                  onPress: () {
                                    model.selectSixtySeconds();
                                    model.fetchName();
                                  },
                                  width: model.selectCard == Select.sixtySeconds
                                      ? kActiveBorderWidth
                                      : kInActiveBorderWidth,
                                  text: "60s",
                                  kTestTextStyle: kTextStyle,
                                ),
                              ),
                            );
                          } else {
                            return Expanded(child: Text(''));
                          }
                        })(),
                        SizedBox(
                          width: 20.0,
                        ),
                        (() {
                          if (model.buttonDisplay == true) {
                            return Expanded(
                              child: Container(
                                width: 130.0,
                                child: SelectedCard(
                                  onPress: () {
                                    model.selectEndless();
                                    model.fetchName();
                                  },
                                  width: model.selectCard == Select.endless
                                      ? kActiveBorderWidth
                                      : kInActiveBorderWidth,
                                  text: "Endless",
                                  kTestTextStyle: kTextStyle,
                                ),
                              ),
                            );
                          } else {
                            return Expanded(child: Text(''));
                          }
                        })(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),

                (() {
                  if (model.buttonDisplay == true) {
                    return Expanded(
                      child: Container(
                        height: 50.0,
                        child: SelectedCard(
                          onPress: () async {
                            model.setName(nickName);
                            if (model.selectCard == Select.endless &&
                                model.nickName == nickName) {
                              result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TestScreen(
                                            selectedCard: model.selectCard,
                                            endlessTapNumber: int.parse(
                                                model.endlessTapNumber),
                                            nickName: model.nickName,
                                          )));
                            } else if (model.selectCard == Select.endless) {
                              result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TestScreen(
                                            selectedCard: model.selectCard,
                                            endlessTapNumber: 0,
                                            nickName: model.nickName,
                                          )));
                            } else {
                              result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TestScreen(
                                            selectedCard: model.selectCard,
                                            nickName: model.nickName,
                                          )));
                            }
                            if (model.selectCard == Select.endless) {
                              model.updateResult(
                                  result.endelessTapNumber.toString());
                              //model.setPrefItems();
                            } else {
                              model.updateResult(result.tapNumber.toString());
                            }
                          },
                          width: kInActiveBorderWidth,
                          text: "PLAY!!",
                          kTestTextStyle: kTextStyle,
                        ),
                      ),
                    );
                  } else {
                    return Expanded(child: Text(''));
                  }
                })(),

                SizedBox(
                  height: 80.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(width:double.infinity,child: Text("SOUND EFFECT:",textAlign: TextAlign.left,style: leadersBoardText,)),
                          Container(width:double.infinity,child: Text("----------",textAlign: TextAlign.left,style:leadersBoardText ,)),
                          SizedBox(height: 15.0,),
                          Container(width:double.infinity,child: Text("Font:",textAlign: TextAlign.left,style: leadersBoardText,)),
                          Container(width:double.infinity,child: Text("SourceSansPro",textAlign: TextAlign.left,style: leadersBoardText,)),
                          Container(width:double.infinity,child: Text("Pacifico",textAlign: TextAlign.left,style: leadersBoardText,)),
                          SizedBox(height: 15.0,),
                          Container(width:double.infinity,child: Text("CON:",textAlign: TextAlign.left,style: leadersBoardText,)),
                          Container(width:double.infinity,child: Text("KOTA",textAlign: TextAlign.left,style: leadersBoardText,)),
                          SizedBox(height: 15.0,),
                          Container(width:double.infinity,child: Text("BACKGROUND:",textAlign: TextAlign.left,style: leadersBoardText,)),
                          Container(width:double.infinity,child: Text("BLACKHOLE",textAlign: TextAlign.left,style: leadersBoardText,)),
                          SizedBox(height: 15.0,),
                          Container(width:double.infinity,child: Text("SPECIAL THANKS:",textAlign: TextAlign.left,style: leadersBoardText,)),
                          Container(width:double.infinity,child: Text("KOTA SUZUKI",textAlign: TextAlign.left,style: leadersBoardText,)),
                          SizedBox(height: 15.0,),
                          Container(width:double.infinity,child: Text("(c)2019 KotaSuzuki Inc.",textAlign: TextAlign.left,style: leadersBoardText,))

                        ],
                      ),
                    ),
                    model.scoreBubbles == null
                        ? Container()
                        : ConstrainedBox(
                            constraints: BoxConstraints.expand(
                                height: 180.0, width: 200.0),
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Color(0xFF1D1E33),
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(children: [
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    "LeaderBoard",
                                    textAlign: TextAlign.left,
                                    style: leaderBoardTitle,
                                  ),
                                ),
                                ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: model.scoreBubbles,
                                )
                              ]),
                            ),
                          ),
                  ],
                ),

                //)
              ],
            );
          }),
        ),
      )),
    );
  }
}
