import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:haptic_feedback/haptic_feedback.dart';

import './global.dart';
import './TCPClient.dart';

class NetworkConfig extends StatefulWidget {
  const NetworkConfig({super.key});

  @override
  State<NetworkConfig> createState() => _NetworkConfigState();
}

class _NetworkConfigState extends State<NetworkConfig> {
  final TCPClient tcp = TCPClient();

  final TextEditingController serverIpController = TextEditingController(
    text: GlobalVariables.serverIp != "" ? GlobalVariables.serverIp : '',
  );
  final TextEditingController serverPortController = TextEditingController(
    text: (GlobalVariables.serverPort).toString() != "0"
        ? (GlobalVariables.serverPort).toString()
        : '',
  );

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false, // 키보드가 화면을 가리지 않도록 설정합니다.
        appBar: AppBar(
          title: const Text('Robot Arm Network Configure'),
        ),
        body: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF363535), // 전체 배경 색상 설정
            ),
            child: SafeArea(
                child: Container(
                    padding:
                        const EdgeInsets.fromLTRB(0, 5, 10, 5), // 컨테이너의 패딩 설정
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                (sizeWidth * 0.3), 10, (sizeWidth * 0.3), 0),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: sizeHeight * 0.1,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Server Ip : ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: (sizeWidth * 0.015),
                                      color: const Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => MessageView.showInputModalnum(
                                      context, 'Server Ip', serverIpController),
                                  child: AbsorbPointer(
                                    child: Container(
                                      width: sizeWidth * 0.25,
                                      height: sizeHeight * 0.1,
                                      margin:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 13, 10, 1),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F3F3),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: (sizeWidth * 0.015),
                                            color: const Color(0xFF2A2A2A)),
                                        decoration: const InputDecoration(
                                            hintText:
                                                'Server Ip(Def.192.168.35.111)',
                                            hintStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 162, 162, 162),
                                            )),
                                        keyboardType: TextInputType.number,
                                        controller: serverIpController,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: sizeWidth * 0.17,
                                  height: sizeHeight * 0.1,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Server PORT : ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: (sizeWidth * 0.015),
                                      color: const Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => MessageView.showInputModalnum(
                                      context,
                                      'Server PORT',
                                      serverPortController),
                                  child: AbsorbPointer(
                                    child: Container(
                                      width: sizeWidth * 0.25,
                                      height: sizeHeight * 0.1,
                                      margin: EdgeInsets.fromLTRB(
                                          0, 5, (sizeWidth * 0.1), 5),
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 13, 10, 1),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F3F3),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: (sizeWidth * 0.015),
                                            color: const Color(0xFF2A2A2A)),
                                        decoration: const InputDecoration(
                                            hintText: 'PORT(Def. 56789)',
                                            hintStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 162, 162, 162),
                                            )),
                                        keyboardType: TextInputType.number,
                                        controller: serverPortController,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // decoration: BoxDecoration(
                            //   color: Color.fromARGB(255, 146, 74, 74),
                            // ),
                            child: SizedBox(
                              width: (sizeWidth * 0.7),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ValueListenableBuilder<bool>(
                                      valueListenable:
                                          GlobalVariables.isTCPConnected,
                                      builder: (context, isTCPConnected, _) {
                                        return Container(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 2,
                                                sigmaY: 2,
                                              ),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Haptics.vibrate(
                                                      HapticsType.light);
                                                  if (GlobalVariables
                                                      .isWifiConnected) {
                                                    GlobalVariables.serverIp =
                                                        serverIpController
                                                                .text.isNotEmpty
                                                            ? serverIpController
                                                                .text
                                                            : "192.168.35.111";
                                                    GlobalVariables
                                                        .serverPort = int.tryParse(
                                                            serverPortController
                                                                .text) ??
                                                        56789;

                                                    if (GlobalVariables
                                                        .isTCPConnected.value) {
                                                      tcp.closeConnection();
                                                    } else {
                                                      if (GlobalVariables
                                                              .serverIp
                                                              .isNotEmpty &&
                                                          GlobalVariables
                                                                  .serverPort >
                                                              0) {
                                                        tcp.connectToServer(
                                                            GlobalVariables
                                                                .serverIp,
                                                            GlobalVariables
                                                                .serverPort);
                                                      } else {
                                                        MessageView
                                                            .showOverlayMessage(
                                                                context,
                                                                sizeWidth,
                                                                "Please Invalid TCP");
                                                        // print('Invalid input');
                                                      }
                                                    }
                                                  } else {
                                                    MessageView.showOverlayMessage(
                                                        context,
                                                        sizeWidth,
                                                        "Please Connect Wifi!");
                                                    // print("Please Connect Wifi");
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: isTCPConnected
                                                      ? const Color.fromARGB(
                                                          255, 194, 116, 116)
                                                      : const Color(
                                                          0xFF748FC2), // 버튼 색상
                                                  elevation: 0,
                                                  padding: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: Container(
                                                  width: (sizeWidth * 0.3),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    isTCPConnected
                                                        ? 'Disconnect'
                                                        : 'Connect',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          (sizeWidth * 0.02),
                                                      color: const Color(
                                                          0xFF2A2A2A),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                  ValueListenableBuilder<bool>(
                                    valueListenable:
                                        GlobalVariables.isTCPConnected,
                                    builder: (context, isTCPConnected, _) {
                                      return Container(
                                        // width: (Size_Width * 0.3),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          isTCPConnected
                                              ? 'Status OK'
                                              : 'Status Fail',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: (sizeWidth * 0.02),
                                            color: isTCPConnected
                                                ? const Color(0xFFF3F3F3)
                                                : const Color.fromARGB(
                                                    255, 210, 121, 121),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          ValueListenableBuilder<bool>(
                              valueListenable: GlobalVariables.isTCPConnected,
                              builder: (context, isTCPConnected, _) {
                                return Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  width: (sizeWidth * 0.3),
                                  height: (sizeHeight * 0.1),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: isTCPConnected
                                        ? const Color(0xFF646667)
                                        : const Color.fromARGB(255, 67, 69, 70),
                                  ),
                                  child: InkWell(
                                    onTap: isTCPConnected
                                        ? () {
                                            MessageView.showOverlayMessage(
                                                context,
                                                sizeHeight,
                                                "Edge Ai Power Off");
                                            tcp.sendMessage(
                                                RobotCommand.createOFFPacket());
                                          }
                                        : null,
                                    child: Container(
                                      width: (sizeWidth * 0.3),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Edge Ai Power Off',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: (sizeWidth * 0.02),
                                            color: isTCPConnected
                                                ? const Color(0xFFFFFFFF)
                                                : const Color.fromARGB(
                                                    123, 255, 255, 255)),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          SizedBox(
                            width: (sizeWidth * 0.15),
                            height: (sizeHeight * 0.15),
                            // color: Color(0xFF212121),
                          ),
                        ])))));
  }
}
