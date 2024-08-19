import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:haptic_feedback/haptic_feedback.dart';

import './global.dart';
import './UDP.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final UDP udp = UDP();
  final TextEditingController padIpController = TextEditingController(
    text: GlobalVariables.PADIp != "" ? GlobalVariables.PADIp : '',
  );
  final TextEditingController padPortController = TextEditingController(
    text: (GlobalVariables.PADPort).toString() != "0"
        ? (GlobalVariables.PADPort).toString()
        : '',
  );
  final TextEditingController targetIpController = TextEditingController(
    text: GlobalVariables.TargetIp != "" ? GlobalVariables.TargetIp : '',
  );
  final TextEditingController targetPortController = TextEditingController(
    text: (GlobalVariables.TargetPort).toString() != "0"
        ? (GlobalVariables.TargetPort).toString()
        : '',
  );
  final FocusNode threshold1FocusNode = FocusNode();
  final FocusNode threshold2FocusNode = FocusNode();
  final FocusNode threshold3FocusNode = FocusNode();
  final FocusNode threshold4FocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
                (sizeWidth * 0.3), 10, (sizeWidth * 0.3), 0),
            child: Text(
              'Network Configure',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: (sizeWidth * 0.02),
                color: const Color(0xFFFFFFFF),
              ),
            ),
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
                    'PAD IP : ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: (sizeWidth * 0.015),
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => MessageView.showInputModal(
                      context, 'PAD IP', padIpController),
                  child: AbsorbPointer(
                    child: Container(
                      width: sizeWidth * 0.25,
                      height: sizeHeight * 0.1,
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 1),
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
                            hintText: 'PAD IP(Def.192.168.0.5)',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 162, 162, 162),
                            )),
                        keyboardType: TextInputType.number,
                        controller: padIpController,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: sizeWidth * 0.17,
                  height: sizeHeight * 0.1,
                  alignment: Alignment.centerRight,
                  child: Text(
                    'PAD PORT : ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: (sizeWidth * 0.015),
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => MessageView.showInputModal(
                      context, 'PAD PORT', padPortController),
                  child: AbsorbPointer(
                    child: Container(
                      width: sizeWidth * 0.25,
                      height: sizeHeight * 0.1,
                      margin: EdgeInsets.fromLTRB(0, 5, (sizeWidth * 0.1), 5),
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 1),
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
                            hintText: 'PORT(Def. 2020)',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 162, 162, 162),
                            )),
                        keyboardType: TextInputType.number,
                        controller: padPortController,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                    'Target IP : ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: (sizeWidth * 0.015),
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => MessageView.showInputModal(
                      context, 'Target IP', targetIpController),
                  child: AbsorbPointer(
                    child: Container(
                      width: sizeWidth * 0.25,
                      height: sizeHeight * 0.1,
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 1),
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
                            hintText: 'Target IP(Def.192.168.0.3)',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 162, 162, 162),
                            )),
                        keyboardType: TextInputType.number,
                        controller: targetIpController,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: sizeWidth * 0.17,
                  height: sizeHeight * 0.1,
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Target PORT : ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: (sizeWidth * 0.015),
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => MessageView.showInputModal(
                      context, 'Target PORT', targetPortController),
                  child: AbsorbPointer(
                    child: Container(
                      width: sizeWidth * 0.25,
                      height: sizeHeight * 0.1,
                      margin: EdgeInsets.fromLTRB(0, 5, (sizeWidth * 0.1), 5),
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 1),
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
                            hintText: 'PORT(Def. 3030)',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 162, 162, 162),
                            )),
                        keyboardType: TextInputType.number,
                        controller: targetPortController,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        child: ElevatedButton(
                          onPressed: () {
                            Haptics.vibrate(HapticsType.light);
                            if (GlobalVariables.isWifiConnected) {
                              GlobalVariables.PADIp =
                                  padIpController.text.isNotEmpty
                                      ? padIpController.text
                                      : "192.168.0.5";
                              GlobalVariables.PADPort =
                                  int.tryParse(padPortController.text) ?? 2020;
                              GlobalVariables.TargetIp =
                                  targetIpController.text.isNotEmpty
                                      ? targetIpController.text
                                      : "192.168.0.3";
                              GlobalVariables.TargetPort =
                                  int.tryParse(targetPortController.text) ??
                                      3030;

                              if (GlobalVariables.PADIp.isNotEmpty &&
                                  GlobalVariables.TargetIp.isNotEmpty &&
                                  GlobalVariables.TargetPort > 0 &&
                                  GlobalVariables.PADPort > 0) {
                                udp.bind(GlobalVariables.PADIp,
                                    GlobalVariables.PADPort);
                                // udp.setTarget(GlobalVariables.TargetIp,
                                //     GlobalVariables.TargetPort);
                                udp.send(
                                    SetTxData.TxData,
                                    GlobalVariables.PADIp,
                                    GlobalVariables.PADPort,
                                    GlobalVariables.TargetIp,
                                    GlobalVariables.TargetPort);
                                // print('setTarget');
                              } else {
                                MessageView.showOverlayMessage(
                                    context, sizeWidth, "Please Invalid UDP");
                                // print('Invalid input');
                              }
                            } else {
                              MessageView.showOverlayMessage(
                                  context, sizeWidth, "Please Connect Wifi!");
                              // print("Please Connect Wifi");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF748FC2), // 버튼 색상
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Container(
                            width: (sizeWidth * 0.3),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            child: Text(
                              'Connect',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: (sizeWidth * 0.02),
                                color: const Color(0xFF2A2A2A),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // width: (Size_Width * 0.3),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      GlobalVariables.isUDPConnected
                          ? 'Status OK'
                          : 'Status Fail',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: (sizeWidth * 0.02),
                        color: GlobalVariables.isUDPConnected
                            ? const Color(0xFFF3F3F3)
                            : const Color.fromARGB(255, 210, 121, 121),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: (sizeWidth * 0.15),
            height: (sizeHeight * 0.15),
            // color: Color(0xFF212121),
          ),
        ]);
  }
}
