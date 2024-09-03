import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';

import './global.dart';
import './setting_view.dart';

import './Network_config.dart';

class MenuButtonSection extends StatefulWidget {
  final double Size_Height;
  final double Size_Width;

  const MenuButtonSection({
    super.key,
    required this.Size_Height,
    required this.Size_Width,
  });

  @override
  _MenuButtonSectionState createState() => _MenuButtonSectionState();
}

class _MenuButtonSectionState extends State<MenuButtonSection> {
  double get sizeHeight => widget.Size_Height;
  double get sizeWidth => widget.Size_Width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
              child: GestureDetector(
                onTap: () {
                  MessageView.showExitConfirmationDialog(context, sizeWidth);
                },
                child: Icon(
                  Icons.meeting_room,
                  size: sizeHeight * 0.07,
                ),
              ),
            ),
          ),
          Container(
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
              child: GestureDetector(
                onTap: () async {
                  Haptics.vibrate(HapticsType.light);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const SettingView();
                    } // SettingView로 이동
                        ),
                  );
                },
                child: Icon(
                  Icons.settings,
                  size: sizeHeight * 0.07,
                ),
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: GlobalVariables.isTCPConnected,
            builder: (context, isTCPConnected, _) {
              return Container(
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
                  child: GestureDetector(
                    onTap: () async {
                      Haptics.vibrate(HapticsType.light);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const NetworkConfig();
                        }),
                      );
                    },
                    child: Icon(
                      isTCPConnected ? Icons.link : Icons.link_off,
                      size: sizeHeight * 0.07,
                    ),
                  ),
                ),
              );
            },
          ),
          ValueListenableBuilder<bool>(
              valueListenable: SetRxData.armError,
              builder: (context, armError, _) {
                return Container(
                  width: (sizeHeight * 0.1),
                  height: (sizeHeight * 0.1),
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
          SizedBox(
            width: (sizeHeight * 0.1),
            height: (sizeHeight * 0.1),
          ),
          Container(
            width: (sizeHeight * 0.1),
            height: (sizeHeight * 0.1),
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
              child: GestureDetector(
                onTap: () {
                  Provider.of<CameraViewModel>(context, listen: false)
                      .togglePlayerState();
                },
                child: Icon(
                  Icons.power_settings_new,
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
