import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'dart:async';

class GlobalVariables {
  static bool Community_Connect = false;
  static String Item_name = "";
  static double Item_X = 0.0;
  static double Item_Y = 0.0;
  static double Item_Z = 0.0;
  static bool Arm_Error = false;

  static bool isWifiConnected = false;
  static bool isURLConnected = false;
  static String Network_URL = "";
}

class MessageView {
  static void showExitConfirmationDialog(
      BuildContext context, double sizeWidth) {
    Haptics.vibrate(HapticsType.light);
    showDialog(
      context: context,
      barrierDismissible: true, // 이 부분을 true로 설정합니다.
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: const Text('앱 종료'),
          content: const Text('앱을 종료하시겠습니까?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Haptics.vibrate(HapticsType.light);
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: Container(
                width: (sizeWidth * 0.07),
                alignment: Alignment.center,
                child: Text(
                  'No',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: sizeWidth * 0.015,
                    color: const Color(0xFFF3F3F3),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Haptics.vibrate(HapticsType.light);
                SystemNavigator.pop(); // 앱 종료
              },
              child: Container(
                width: (sizeWidth * 0.07),
                alignment: Alignment.center,
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: sizeWidth * 0.015,
                    color: const Color(0xFFF3F3F3),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showOverlayMessage(
      BuildContext context, double sizeWidth, String message) {
    Haptics.vibrate(HapticsType.light);
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: sizeWidth * 0.05,
                  color: const Color(0xFFF3F3F3),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // 일정 시간 후에 Overlay를 제거합니다.
    Future.delayed(const Duration(milliseconds: 700), () {
      overlayEntry.remove();
    });
  }

  static void showInputModal(
      BuildContext context, String label, TextEditingController controller) {
    FocusNode focusNode = FocusNode();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(focusNode);
        });

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: label),
                  onSubmitted: (value) {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CameraViewModel extends ChangeNotifier {
  Offset? _touchPosition;
  String _touchPositionText = '';
  String _networkURL = "rtsp://210.99.70.120:1935/live/cctv003.stream";

  Offset? get touchPosition => _touchPosition;
  String get touchPositionText => _touchPositionText;
  String get networkURL => _networkURL;

  void updateTouchPosition(Offset position, String text) {
    _touchPosition = position;
    _touchPositionText = text;
    notifyListeners();
  }

  void clearTouchPosition() {
    _touchPosition = null;
    _touchPositionText = '';
    notifyListeners();
  }

  void updateNetworkURL(String url) {
    _networkURL = url;
    notifyListeners(); // URL 변경 시 리스너들에게 알림
  }
}
