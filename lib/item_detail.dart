import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './global.dart';
import './camera_view.dart';
import './TCPClient.dart';

class ItemDetails extends StatefulWidget {
  final double Size_Height; // 위젯의 높이를 설정하는 변수
  final double Size_Width; // 위젯의 너비를 설정하는 변수

  const ItemDetails(
      {super.key, required this.Size_Height, required this.Size_Width});

  @override
  _ItemDetailsState createState() =>
      _ItemDetailsState(); // 위젯의 상태를 관리하는 _ItemDetailsState를 생성합니다.
}

class _ItemDetailsState extends State<ItemDetails> {
  // 위젯의 상태를 관리하는 클래스입니다.

  final TCPClient tcp = TCPClient();
  double get sizeHeight => widget.Size_Height; // 위젯의 높이를 반환하는 getter
  double get sizeWidth => widget.Size_Width; // 위젯의 너비를 반환하는 getter

  @override
  Widget build(BuildContext context) {
    // 위젯의 UI를 구축하는 메서드입니다.
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Text(
                  '상품명 :',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: (sizeWidth * 0.025), // 화면 너비의 2.5%로 폰트 크기 설정
                    color: const Color(0xFFF3F3F3),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    height: sizeHeight * 0.19, // 화면 높이의 21%로 높이 설정
                    alignment: Alignment.centerLeft,
                    child: ValueListenableBuilder<String>(
                      valueListenable: SetRxData.itemName,
                      builder: (context, value, child) {
                        return Text(
                          SetRxData.itemName.value, // GlobalVariables에서 가져온 상품명
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeWidth * 0.02, // 화면 너비의 2%로 폰트 크기 설정
                            color: const Color(0xFF646667),
                          ),
                        );
                      },
                    )),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ValueListenableBuilder<String>(
                      valueListenable: SetRxData.itemName,
                      builder: (context, itemName, child) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          width: (sizeWidth * 0.15),
                          height: (sizeHeight * 0.09),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: itemName.isNotEmpty
                                ? const Color(0xFF646667)
                                : const Color.fromARGB(255, 67, 69, 70),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x40000000),
                                offset: Offset(0, 4),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: itemName.isNotEmpty
                                ? () {
                                    /*  MessageView.showOverlayMessage(
                                    context, sizeHeight, "Add to cart버튼 클릭");*/
                                    tcp.sendMessage(
                                        RobotCommand.createCommandPacket());
                                  }
                                : null,
                            child: Container(
                              width: (sizeWidth * 0.2),
                              alignment: Alignment.center,
                              child: Text(
                                'Add to cart',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: (sizeWidth * 0.025),
                                    color: itemName.isNotEmpty
                                        ? const Color(0xFFFFFFFF)
                                        : const Color.fromARGB(
                                            123, 255, 255, 255)),
                              ),
                            ),
                          ),
                        );
                      }),
                  /*     ValueListenableBuilder<bool>(
                  valueListenable: GlobalVariables.pick,
                  builder: (context, pick, child) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      width: (sizeWidth * 0.15),
                      height: (sizeHeight * 0.1),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: GlobalVariables.pick.value
                            ? const Color.fromARGB(255, 85, 166, 212)
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
                        onTap: () {
                          if (!GlobalVariables.isTCPConnected.value) {
                            MessageView.showOverlayMessage(
                                context,
                                MediaQuery.of(context).size.width,
                                "로봇이 연결되지 않았습니다.");
                          } else {
                            GlobalVariables.pick.value =
                                !GlobalVariables.pick.value;

                            if (GlobalVariables.pick.value) {
                              tcp.sendMessage(
                                  RobotCommand.createpickoffPacket());
                            } else {
                              tcp.sendMessage(RobotCommand.createpickPacket());
                            }
                          }
                        },
                        child: Container(
                          width: (sizeWidth * 0.2),
                          alignment: Alignment.center,
                          child: Text(
                            pick ? 'Pick Up' : 'Put Down',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: (sizeWidth * 0.025),
                                color: const Color(0xFFFFFFFF)),
                          ),
                        ),
                      ),
                    );
                  }),*/
                  Container(
                    width: (sizeWidth * 0.15), // 화면 너비의 15%로 너비 설정
                    height: (sizeHeight * 0.09), // 화면 높이의 10%로 높이 설정
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          sizeHeight * 0.1), // 높이에 비례하여 둥근 모서리 설정
                      color: const Color(0xFF646667),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000),
                          offset: Offset(0, 4),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<CameraViewModel>(context, listen: false)
                            .clearTouchPosition();

                        tcp.sendMessage(RobotCommand.createCancelPacket());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF646667), // 버튼 색상
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Container(
                        width: (sizeWidth * 0.2), // 화면 너비의 20%로 너비 설정
                        alignment: Alignment.center,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize:
                                (sizeWidth * 0.025), // 화면 너비의 2.5%로 폰트 크기 설정
                            color: const Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]));
  }
}
