import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';

import './global.dart';

import './MqttService.dart';

class command_button extends StatefulWidget {
  final double Size_Height;
  final double Size_Width;

  const command_button({
    super.key,
    required this.Size_Height,
    required this.Size_Width,
  });

  @override
  _command_buttonState createState() => _command_buttonState();
}

class _command_buttonState extends State<command_button> {
  final MqttService mqtt = MqttService();
  double get sizeHeight => widget.Size_Height;
  double get sizeWidth => widget.Size_Width;

  /* Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('안내를 요청하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // 아니오 선택
                child: const Text('아니오'),
              ),
              TextButton(
                onPressed: () {
                  mqtt.sendMqttStart();
                  Navigator.of(context).pop(false);
                }, // 네 선택
                child: const Text('네'),
              ),
            ],
          ),
        ) ??
        false;
  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (GlobalVariables.showContainer
              ? GestureDetector(
                  onTap: () {
                    mqtt.sendMqttStart();
                    MessageView.showOverlayMessage(
                        context, sizeHeight, "찾으시는 것을 말씀해주세요.");
                  },
                  child: Container(
                    width: (sizeHeight * 0.1),
                    height: (sizeHeight * 0.1),
                    margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sizeHeight * 0.1),
                      color: const Color(0xFF646667),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000),
                          offset: Offset(0, 4),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.mic,
                        size: sizeHeight * 0.07,
                      ),
                    ),
                  ),
                )
              : Container(
                  width: (sizeHeight * 0.1),
                  height: (sizeHeight * 0.1),
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0))),
          ValueListenableBuilder<bool>(
              valueListenable: SetRxData.armError,
              builder: (context, armError, _) {
                return Container(
                  width: (sizeHeight * 0.1),
                  height: (sizeHeight * 0.1),
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sizeHeight * 0.1),
                    color: armError
                        ? const Color.fromARGB(255, 110, 232, 141)
                        : const Color(0xFFE86E6E),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        offset: Offset(0, 4),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                );
              }),
          GestureDetector(
            onTap: () {
              Scaffold.of(context).openEndDrawer(); // 드로어 열기
            },
            child: Container(
              width: (sizeHeight * 0.1),
              height: (sizeHeight * 0.1),
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sizeHeight * 0.1),
                color: const Color(0xFF646667),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40000000),
                    offset: Offset(0, 4),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.menu,
                  size: sizeHeight * 0.07,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
