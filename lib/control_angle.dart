import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import './global.dart';
import './TCPClient.dart';

class CameraAngleControls extends StatefulWidget {
  final double Size_Height;
  final double Size_Width;
  final Function _buildTriangleButton;

  const CameraAngleControls({
    super.key,
    required this.Size_Height,
    required this.Size_Width,
    required Function buildTriangleButton,
  }) : _buildTriangleButton = buildTriangleButton;

  @override
  _CameraAngleControlsState createState() => _CameraAngleControlsState();
}

class _CameraAngleControlsState extends State<CameraAngleControls> {
  double get sizeHeight => widget.Size_Height;
  double get sizeWidth => widget.Size_Width;
  Function get buildTriangleButton => widget._buildTriangleButton;

  final TCPClient tcp = TCPClient();
  Timer? timer;

  void startForwardSignal(int num) {
    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      /* MessageView.showOverlaybtnMessage(
              context, size, "Sending signal for $num");*/

      tcp.sendMessage(RobotCommand.createButtonPacket(num));
    });
  }

  void stopForwardSignal() {
    timer?.cancel();
  }

  Widget createButton(
    double size, // 버튼의 크기를 조정할 배율 인자
    double height, // 버튼의 높이
    double width, // 버튼의 너비
    bool istopLeft, // 왼쪽 상단 모서리 둥글기 여부
    bool istopRight, // 오른쪽 상단 모서리 둥글기 여부
    bool isbottomLeft, // 왼쪽 하단 모서리 둥글기 여부
    bool isbottomRight, // 오른쪽 하단 모서리 둥글기 여부
    int num,
  ) {
    return GestureDetector(
      onTapDown: (_) {
        if (!GlobalVariables.isTCPConnected.value) {
          MessageView.showOverlayMessage(
              context, MediaQuery.of(context).size.width, "로봇이 연결되지 않았습니다.");
        } else {
          if (!SetRxData.armError.value) {
            print('Arm is working');
            MessageView.showOverlayMessage(context,
                MediaQuery.of(context).size.width, "로봇이 이전 명령을 수행 중입니다.");
          } else {
            Provider.of<CameraViewModel>(context, listen: false)
                .cancelcoordinate();
            tcp.sendMessage(RobotCommand.createButtonPacket(num + 1));
            startForwardSignal(num + 1);
          }
        }
      },
      onTapUp: (_) {
        stopForwardSignal();
        // MessageView.showOverlaybtnMessage(context, size, "Button released");
      },
      onTapCancel: () {
        stopForwardSignal();
        // MessageView.showOverlaybtnMessage(context, size, "Button canceled");
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
            if (!GlobalVariables.isTCPConnected.value) {
              MessageView.showOverlayMessage(context,
                  MediaQuery.of(context).size.width, "로봇이 연결되지 않았습니다.");
            } else {
              if (!SetRxData.armError.value) {
                print('Arm is working');
                MessageView.showOverlayMessage(context,
                    MediaQuery.of(context).size.width, "로봇이 이전 명령을 수행 중입니다.");
              } else {
                Provider.of<CameraViewModel>(context, listen: false)
                    .cancelcoordinate();
                switch (num) {
                  case 2:
                    int btnnum = num + 1;
                    tcp.sendMessage(RobotCommand.createButtonPacket(btnnum));
                    break;

                  case 3:
                    int btnnum = num + 1;

                    tcp.sendMessage(RobotCommand.createButtonPacket(btnnum));
                    break;

                  case 4:
                    int btnnum = num + 1;

                    tcp.sendMessage(RobotCommand.createButtonPacket(btnnum));
                    break;

                  case 5:
                    int btnnum = num + 1;

                    tcp.sendMessage(RobotCommand.createButtonPacket(btnnum));
                    break;

                  case 8:
                    int btnnum = num + 1;

                    tcp.sendMessage(RobotCommand.createButtonPacket(btnnum));
                    break;

                  case 9:
                    int btnnum = num + 1;

                    tcp.sendMessage(RobotCommand.createButtonPacket(btnnum));
                    break;

                  case 10:
                    int btnnum = num + 1;

                    tcp.sendMessage(RobotCommand.createButtonPacket(btnnum));
                    break;

                  case 11:
                    int btnnum = num + 1;

                    tcp.sendMessage(RobotCommand.createButtonPacket(btnnum));
                    break;
                }
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF646667), // 버튼 배경색
            elevation: 0, // 버튼의 그림자 높이
            padding: EdgeInsets.zero, // 버튼의 패딩 설정
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: istopLeft ? Radius.circular(size) : Radius.zero,
                bottomLeft: isbottomLeft ? Radius.circular(size) : Radius.zero,
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
                bottomLeft: isbottomLeft ? Radius.circular(size) : Radius.zero,
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizeHeight * 0.37,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF454343),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Camera Angle',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: sizeWidth * 0.02,
                  color: const Color(0xFFF3F3F3),
                ),
              ),
              SizedBox(width: sizeHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  createButton(
                    sizeHeight,
                    0.15,
                    0.1,
                    true,
                    false,
                    true,
                    false,
                    5,
                  ),
                  SizedBox(width: sizeHeight * 0.008),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      createButton(
                        sizeHeight,
                        0.1,
                        0.15,
                        true,
                        true,
                        false,
                        false,
                        2,
                      ),
                      SizedBox(height: sizeHeight * 0.008),
                      Container(
                        width: sizeHeight * 0.08,
                        height: sizeHeight * 0.08,
                        decoration: BoxDecoration(
                          color: const Color(0xFF646667),
                          borderRadius:
                              BorderRadius.circular(sizeHeight * 0.08),
                        ),
                        child: Center(
                          child: GestureDetector(
                            child: Icon(
                              Icons.cached,
                              size: sizeHeight * 0.05,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sizeHeight * 0.008),
                      createButton(
                        sizeHeight,
                        0.1,
                        0.15,
                        false,
                        false,
                        true,
                        true,
                        3,
                      ),
                    ],
                  ),
                  SizedBox(width: sizeHeight * 0.008),
                  createButton(
                    sizeHeight,
                    0.15,
                    0.1,
                    false,
                    true,
                    false,
                    true,
                    4,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
