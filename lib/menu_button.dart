import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

import './global.dart';
import './setting_view.dart';
import './bt_classic/Bluetoothpage.dart';

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
            valueListenable: GlobalVariables.communityConnect,
            builder: (context, communityConnect, _) {
              return Container(
                width: (sizeHeight * 0.1),
                height: (sizeHeight * 0.1),
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sizeHeight * 0.1),
                  color: communityConnect
                      ? const Color.fromARGB(255, 63, 105, 255)
                      : const Color(0xFF646667),
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
                      Haptics.vibrate(HapticsType.light);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const BluetoothPage();
                        }),
                      );

                      GlobalVariables.armError.value =
                          communityConnect ? true : false;
                    },
                    child: Icon(
                      communityConnect
                          ? Icons.bluetooth_connected
                          : Icons.bluetooth,
                      size: sizeHeight * 0.07,
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: (sizeHeight * 0.1),
            height: (sizeHeight * 0.1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sizeHeight * 0.1),
              color: GlobalVariables.armError.value
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
          ),
        ],
      ),
    );
  }
}
