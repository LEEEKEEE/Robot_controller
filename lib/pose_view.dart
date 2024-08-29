import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './global.dart';
import './TCPClient.dart';

class PoseControls extends StatefulWidget {
  final double Size_Height;
  final double Size_Width;
  final Function _buildTriangleButton;

  const PoseControls({
    super.key,
    required this.Size_Height,
    required this.Size_Width,
    required Function buildTriangleButton,
  }) : _buildTriangleButton = buildTriangleButton;

  @override
  _PoseControlsState createState() => _PoseControlsState();
}

class _PoseControlsState extends State<PoseControls> {
  double get sizeHeight => widget.Size_Height;
  double get sizeWidth => widget.Size_Width;
  Function get buildTriangleButton => widget._buildTriangleButton;
  final TCPClient tcp = TCPClient();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CameraViewModel>(context);
    return Container(
        height: sizeHeight * 0.37,
        margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF454343),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Pose',
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: sizeHeight * 0.14, // 버튼의 높이 설정
                        width: sizeHeight * 0.14, // 버튼의 너비 설정
                        decoration: const BoxDecoration(
                          color: Color(0xFF646667), // 버튼 배경색
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.zero,
                            bottomLeft: Radius.zero,
                            topRight: Radius.zero,
                            bottomRight: Radius.zero,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x40000000), // 그림자 색상
                              offset: Offset(0, 4), // 그림자의 위치
                              blurRadius: 2, // 그림자의 블러 반경
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (viewModel.touchPosition != null) {
                              Provider.of<CameraViewModel>(context,
                                      listen: false)
                                  .clearTouchPosition();

                              tcp.sendMessage(
                                  RobotCommand.createCancelPacket());
                            }
                            tcp.sendMessage(RobotCommand.createButtonPacket(1));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF646667), // 버튼 배경색
                            elevation: 0, // 버튼의 그림자 높이
                            padding: EdgeInsets.zero, // 버튼의 패딩 설정
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                bottomLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                            ),
                          ),
                          child: Container(
                            height: sizeHeight * 0.11, // 버튼의 자식 컨테이너 높이
                            width: sizeHeight * 0.11, // 버튼의 자식 컨테이너 너비
                            decoration: const BoxDecoration(
                              color: Color(0xFF646667), // 자식 컨테이너 배경색
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                bottomLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF2A2A2A), // 자식 컨테이너의 그림자 색상
                                  spreadRadius: 1, // 그림자의 확산 반경
                                  blurRadius: 1, // 그림자의 블러 반경
                                  offset: Offset(0, 0), // 그림자의 위치
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.settings_backup_restore,
                                size: sizeHeight * 0.07,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sizeHeight * 0.015),
                      Container(
                        height: sizeHeight * 0.14, // 버튼의 높이 설정
                        width: sizeHeight * 0.14, // 버튼의 너비 설정
                        decoration: const BoxDecoration(
                          color: Color(0xFF646667), // 버튼 배경색
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.zero,
                            bottomLeft: Radius.zero,
                            topRight: Radius.zero,
                            bottomRight: Radius.zero,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x40000000), // 그림자 색상
                              offset: Offset(0, 4), // 그림자의 위치
                              blurRadius: 2, // 그림자의 블러 반경
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (viewModel.touchPosition != null) {
                              Provider.of<CameraViewModel>(context,
                                      listen: false)
                                  .clearTouchPosition();

                              tcp.sendMessage(
                                  RobotCommand.createCancelPacket());
                            }
                            tcp.sendMessage(RobotCommand.createButtonPacket(2));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF646667), // 버튼 배경색
                            elevation: 0, // 버튼의 그림자 높이
                            padding: EdgeInsets.zero, // 버튼의 패딩 설정
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                bottomLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                            ),
                          ),
                          child: Container(
                            height: sizeHeight * 0.11, // 버튼의 자식 컨테이너 높이
                            width: sizeHeight * 0.11, // 버튼의 자식 컨테이너 너비
                            decoration: const BoxDecoration(
                              color: Color(0xFF646667), // 자식 컨테이너 배경색
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                bottomLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF2A2A2A), // 자식 컨테이너의 그림자 색상
                                  spreadRadius: 1, // 그림자의 확산 반경
                                  blurRadius: 1, // 그림자의 블러 반경
                                  offset: Offset(0, 0), // 그림자의 위치
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.home,
                                size: sizeHeight * 0.07,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ));
  }
}
