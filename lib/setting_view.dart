import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';

import './global.dart';
import './main.dart';
import './camera_view.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final TextEditingController URLController = TextEditingController(
    text: GlobalVariables.Network_URL != "" ? GlobalVariables.Network_URL : '',
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
                            child: Text(
                              'Streaming Configure',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: (sizeWidth * 0.02),
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
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
                                  'Streaming URL : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: (sizeWidth * 0.015),
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => MessageView.showInputModal(
                                    context, 'Streaming URL', URLController),
                                child: AbsorbPointer(
                                  child: Container(
                                    width: sizeWidth * 0.70,
                                    height: sizeHeight * 0.1,
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 1),
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
                                              'Streaming URL(Def.rtp://@:5000)',
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
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Haptics.vibrate(HapticsType.light);

                                            GlobalVariables.Network_URL =
                                                URLController.text.isNotEmpty
                                                    ? URLController.text
                                                    : "rtp://@:5000";
                                            Provider.of<CameraViewModel>(
                                                    context,
                                                    listen: false)
                                                .updateNetworkURL(
                                                    GlobalVariables
                                                        .Network_URL);

                                            Navigator.pop(context);

                                            if (GlobalVariables
                                                .Network_URL.isNotEmpty) {
                                            } else {
                                              MessageView.showOverlayMessage(
                                                  context,
                                                  sizeWidth,
                                                  "Please Invalid URL");
                                              // print('Invalid input');
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                                0xFF748FC2), // 버튼 색상
                                            elevation: 0,
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Container(
                                            width: (sizeWidth * 0.3),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
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
                                ],
                              ),
                            ),
                          ),
                        ])))));
  }
}
