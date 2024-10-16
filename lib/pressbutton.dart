import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './global.dart';
import './camera_view.dart';
import './TCPClient.dart';

class PressButton extends StatefulWidget {
  final double Size_Height; // 위젯의 높이를 설정하는 변수
  final double Size_Width; // 위젯의 너비를 설정하는 변수

  const PressButton(
      {super.key, required this.Size_Height, required this.Size_Width});

  @override
  _PressButtonState createState() => _PressButtonState();
}

class _PressButtonState extends State<PressButton> {
  // 위젯의 상태를 관리하는 클래스입니다.

  final TCPClient tcp = TCPClient();
  double get sizeHeight => widget.Size_Height; // 위젯의 높이를 반환하는 getter
  double get sizeWidth => widget.Size_Width; // 위젯의 너비를 반환하는 getter

  @override
  Widget build(BuildContext context) {
    // 위젯의 UI를 구축하는 메서드입니다.
    return ValueListenableBuilder<bool>(
        valueListenable: SetRxData.itemExist,
        builder: (context, itemExist, child) {
          return Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            height: (sizeHeight * 0.18),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: itemExist
                  ? const Color.fromARGB(255, 67, 69, 70)
                  : const Color(0xFF646667),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x40000000),
                  offset: Offset(0, 4),
                  blurRadius: 2,
                ),
              ],
            ),
            child: InkWell(
              onTap: itemExist
                  ? null
                  : () {
                      MessageView.showOverlayMessage(
                          context, sizeHeight, "로봇이 곧 동작합니다.");
                      tcp.sendMessage(RobotCommand.createPressPacket());
                      SetRxData.itemExist.value = true;
                    },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Button Press',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: (sizeWidth * 0.025),
                      color: itemExist
                          ? const Color.fromARGB(123, 255, 255, 255)
                          : const Color(0xFFFFFFFF)),
                ),
              ),
            ),
          );
        });
  }
}
