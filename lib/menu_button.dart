import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import './global.dart';
import './setting_view.dart';
import './MqttService.dart';
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
  final MqttService mqtt = MqttService();
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
          GestureDetector(
            onTap: () {
              MessageView.showExitConfirmationDialog(context, sizeWidth);
            },
            child: Container(
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
                child: Icon(
                  Icons.meeting_room,
                  size: sizeHeight * 0.07,
                ),
              ),
            ),
          ),
          (GlobalVariables.showContainer
              ? ValueListenableBuilder<MqttConnectionState>(
                  valueListenable: mqtt.connectionState,
                  builder: (context, connectionState, _) {
                    Icon mqttIcon;
                    if (connectionState == MqttConnectionState.connected) {
                      mqttIcon = Icon(
                        Icons.settings,
                        size: sizeHeight * 0.07,
                      );
                    } else {
                      mqttIcon = Icon(
                        Icons.settings_outlined,
                        size: sizeHeight * 0.07,
                      );
                    }

                    return GestureDetector(
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
                      child: Container(
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
                          child: mqttIcon,
                        ),
                      ),
                    );
                  })
              : Container()),
          GestureDetector(
              onTap: () async {
                Haptics.vibrate(HapticsType.light);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const NetworkConfig();
                  }),
                );
              },
              child: ValueListenableBuilder<bool>(
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
                      child: Icon(
                        isTCPConnected ? Icons.link : Icons.link_off,
                        size: sizeHeight * 0.07,
                      ),
                    ),
                  );
                },
              )),
          SizedBox(
            width: (sizeHeight * 0.1),
            height: (sizeHeight * 0.1),
          ),
          SizedBox(
            width: (sizeHeight * 0.1),
            height: (sizeHeight * 0.1),
          ),
          (GlobalVariables.showContainer
              ? Container()
              : Container(
                  width: (sizeHeight * 0.1),
                  height: (sizeHeight * 0.1),
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0))),
          ValueListenableBuilder<bool>(
              valueListenable: GlobalVariables.player,
              builder: (context, player, _) {
                return GestureDetector(
                  onTap: () {
                    Provider.of<CameraViewModel>(context, listen: false)
                        .togglePlayerState();
                  },
                  child: Container(
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
                      child: Icon(
                        GlobalVariables.player.value
                            ? Icons.videocam
                            : Icons.videocam_off,
                        size: sizeHeight * 0.07,
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
