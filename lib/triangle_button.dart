import 'dart:async';
import 'package:flutter/material.dart';

import './global.dart';
import 'bt_classic/bluetoothmanager.dart';

void showOverlayMessage(BuildContext context, double size, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Widget buildTriangleButton(
  BuildContext context,
  double size, // 버튼의 크기를 조정할 배율 인자
  double height, // 버튼의 높이
  double width, // 버튼의 너비
  bool istopLeft, // 왼쪽 상단 모서리 둥글기 여부
  bool istopRight, // 오른쪽 상단 모서리 둥글기 여부
  bool isbottomLeft, // 왼쪽 하단 모서리 둥글기 여부
  bool isbottomRight, // 오른쪽 하단 모서리 둥글기 여부
  int num, // 버튼이 눌렸을 때 표시할 메시지 인덱스
) {
  return StatefulBuilder(
    builder: (context, setState) {
      Timer? timer;
      final bluetoothManager = BluetoothManager();

      void startForwardSignal() {
        timer?.cancel();
        timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
          MessageView.showOverlayMessage(
              context, size, "Sending signal for $num");

          //setState(() {
          //   SetTxData.pressed_btn_num = num;
          //  });

          bluetoothManager.sendMessage([num]);
        });
      }

      void stopForwardSignal() {
        timer?.cancel();
      }

      return GestureDetector(
        onTapDown: (_) {
          MessageView.showOverlayMessage(
              context, size, "Sending signal for $num");
          startForwardSignal();
        },
        onTapUp: (_) {
          stopForwardSignal();
        },
        onTapCancel: () {
          stopForwardSignal();
        },
        child: Container(
          height: size * height, // 버튼의 높이 설정
          width: size * width, // 버튼의 너비 설정
          decoration: BoxDecoration(
            color: const Color(0xFF646667), // 버튼 배경색
            borderRadius: BorderRadius.only(
              topLeft: istopLeft ? Radius.circular(size) : Radius.zero,
              bottomLeft: isbottomLeft ? Radius.circular(size) : Radius.zero,
              topRight: istopRight ? Radius.circular(size) : Radius.zero,
              bottomRight: isbottomRight ? Radius.circular(size) : Radius.zero,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000), // 그림자 색상
                offset: Offset(0, 4), // 그림자의 위치
                blurRadius: 2, // 그림자의 블러 반경
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              // 버튼이 눌렸을 때의 동작 설정
              switch (num) {
                case 0:
                  MessageView.showOverlayMessage(
                      context, size, "Sending signal for $num");
                  bluetoothManager.sendMessage([num]);
                  break;
                case 1:
                  MessageView.showOverlayMessage(
                      context, size, "Sending signal for $num");
                  bluetoothManager.sendMessage([num]);
                  break;
                case 2:
                  MessageView.showOverlayMessage(
                      context, size, "Sending signal for $num");
                  bluetoothManager.sendMessage([num]);
                  break;
                case 3:
                  MessageView.showOverlayMessage(
                      context, size, "Sending signal for $num");
                  bluetoothManager.sendMessage([num]);
                  break;
                case 4:
                  MessageView.showOverlayMessage(
                      context, size, "Sending signal for $num");
                  bluetoothManager.sendMessage([num]);
                  break;
                case 5:
                  MessageView.showOverlayMessage(
                      context, size, "Sending signal for $num");
                  bluetoothManager.sendMessage([num]);
                  break;
                case 6:
                  MessageView.showOverlayMessage(
                      context, size, "Sending signal for $num");
                  bluetoothManager.sendMessage([num]);
                  break;
                case 7:
                  MessageView.showOverlayMessage(
                      context, size, "Sending signal for $num");
                  bluetoothManager.sendMessage([num]);
                  break;
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF646667), // 버튼 배경색
              elevation: 0, // 버튼의 그림자 높이
              padding: EdgeInsets.zero, // 버튼의 패딩 설정
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: istopLeft ? Radius.circular(size) : Radius.zero,
                  bottomLeft:
                      isbottomLeft ? Radius.circular(size) : Radius.zero,
                  topRight: istopRight ? Radius.circular(size) : Radius.zero,
                  bottomRight:
                      isbottomRight ? Radius.circular(size) : Radius.zero,
                ),
              ),
            ),
            child: Container(
              height: size * (height - 0.03), // 버튼의 자식 컨테이너 높이
              width: size * (width - 0.03), // 버튼의 자식 컨테이너 너비
              decoration: BoxDecoration(
                color: const Color(0xFF646667), // 자식 컨테이너 배경색
                borderRadius: BorderRadius.only(
                  topLeft: istopLeft ? Radius.circular(size) : Radius.zero,
                  bottomLeft:
                      isbottomLeft ? Radius.circular(size) : Radius.zero,
                  topRight: istopRight ? Radius.circular(size) : Radius.zero,
                  bottomRight:
                      isbottomRight ? Radius.circular(size) : Radius.zero,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF2A2A2A), // 자식 컨테이너의 그림자 색상
                    spreadRadius: 1, // 그림자의 확산 반경
                    blurRadius: 1, // 그림자의 블러 반경
                    offset: Offset(0, 0), // 그림자의 위치
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
