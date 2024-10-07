import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';
import 'package:mqtt_client/mqtt_client.dart';

import './global.dart';
import './main.dart';
import './camera_view.dart';
import './MqttService.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final MqttService mqtt = MqttService();
  final TextEditingController URLController = TextEditingController(
    text: GlobalVariables.broker_URI != "" ? GlobalVariables.broker_URI : '',
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false, // 키보드가 화면을 가리지 않도록 설정합니다.
        appBar: AppBar(
          title: const Text('MQTT Concection'),
        ),
        body: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF363535), // 전체 배경 색상 설정
            ),
            child: SafeArea(
                child: Container(
                    padding:
                        const EdgeInsets.fromLTRB(10, 5, 10, 5), // 컨테이너의 패딩 설정
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: sizeHeight * 0.1,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Broker URI : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: (sizeWidth * 0.015),
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => MessageView.showInputModal(
                                    context, 'Broker URI', URLController),
                                child: AbsorbPointer(
                                  child: Container(
                                    width: sizeWidth * 0.70,
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
                                              'Broker URI(Def.broker.able-ai.kr)',
                                          hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 162, 162, 162),
                                          )),
                                      keyboardType: TextInputType.text,
                                      controller: URLController,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
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
                                  Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 2,
                                            sigmaY: 2,
                                          ),
                                          child: ValueListenableBuilder<
                                                  MqttConnectionState>(
                                              valueListenable:
                                                  mqtt.connectionState,
                                              builder: (context,
                                                  connectionState, _) {
                                                Color buttoncolor;
                                                String text;
                                                if (connectionState ==
                                                    MqttConnectionState
                                                        .connected) {
                                                  buttoncolor =
                                                      const Color.fromARGB(
                                                          255, 194, 116, 116);
                                                  text = "Disconnect";
                                                } else {
                                                  buttoncolor =
                                                      const Color(0xFF748FC2);
                                                  text = "Connect";
                                                }

                                                return ElevatedButton(
                                                  onPressed: () {
                                                    if (GlobalVariables
                                                        .isWifiConnected) {
                                                      /*
                                                      GlobalVariables
                                                              .broker_URI =
                                                          URLController.text
                                                                  .isNotEmpty
                                                              ? URLController
                                                                  .text
                                                              : "broker.able-ai.kr";*/

                                                      if (connectionState ==
                                                          MqttConnectionState
                                                              .connected) {
                                                        mqtt.disconnect();
                                                      } else {
                                                        /*  if (GlobalVariables
                                                            .broker_URI
                                                            .isNotEmpty) {*/
                                                        mqtt.connect();
                                                        /*   } else {
                                                          MessageView
                                                              .showOverlayMessage(
                                                                  context,
                                                                  sizeWidth,
                                                                  "Please Invalid URI");
                                                          // print('Invalid input');
                                                        }*/
                                                      }
                                                    } else {
                                                      MessageView
                                                          .showOverlayMessage(
                                                              context,
                                                              sizeWidth,
                                                              "Please Invalid URI");
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        buttoncolor, // 버튼 색상
                                                    elevation: 0,
                                                    padding: EdgeInsets.zero,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    width: (sizeWidth * 0.3),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      text,
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
                                                );
                                              })),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                (sizeWidth * 0.3), 10, (sizeWidth * 0.3), 0),
                          ),
                        ])))));
  }
}
