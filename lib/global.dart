import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:connectivity/connectivity.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import './TCPClient.dart';

class GlobalVariables {
  static bool Screen_Off = false;
  static int txtimer_duration = 50;
  static int rxtimer_duration = 50;

  static bool isWifiConnected = false;
  static bool isURLConnected = false;
  static bool showContainer = true;

  static String broker_URI = "";
  static String serverIp = "";
  static int serverPort = 0;

  static DateTime nowDateTime = DateTime.now();
  static DateTime sendDateTime = DateTime.now();
  static DateTime reavDateTime = DateTime.now();

  static ValueNotifier<bool> isTCPConnected = ValueNotifier<bool>(false);
  static ValueNotifier<bool> mqttConnected = ValueNotifier<bool>(false);
  static ValueNotifier<bool> pick = ValueNotifier<bool>(true);
  static ValueNotifier<bool> picking = ValueNotifier<bool>(true);
  static ValueNotifier<bool> player = ValueNotifier<bool>(true);
  static ValueNotifier<bool> addToCart = ValueNotifier<bool>(false);
}

class SetTxData {
  static int Event_Type = 0;
  static int Button_num = 0;
}

class SetRxData {
  static ValueNotifier<bool> armError = ValueNotifier<bool>(false);
  static ValueNotifier<bool> angleError = ValueNotifier<bool>(true);
  static ValueNotifier<bool> itemExist = ValueNotifier<bool>(true);
  static ValueNotifier<String> itemName = ValueNotifier<String>('');
}

class RobotCommand {
  static const int PACKET_START = 0xAA;
  static const int PACKET_END = 0xDD;

  static const int EVENT_IP = 0x00;
  static const int EVENT_BUTTON = 0x01;
  static const int EVENT_TOUCH = 0x02;
  static const int EVENT_COMMAND = 0x03;
  static const int EVENT_CANCEL = 0x04;
  static const int EVENT_OFF = 0x05;
  static const int EVENT_TOUCHELEVATE = 0x06;
  static const int EVENT_PRESS = 0x07;

  static Uint8List createIPPacket(String ipAddress) {
    List<String> ipSegments = ipAddress.split('.');
    int byte1 = int.parse(ipSegments[0]);
    int byte2 = int.parse(ipSegments[1]);
    int byte3 = int.parse(ipSegments[2]);
    int byte4 = int.parse(ipSegments[3]);

    ByteData packet = ByteData(8);

    packet.setUint8(0, PACKET_START);
    packet.setUint8(1, EVENT_IP);
    packet.setUint8(2, 4); // 데이터 길이 4바이트
    packet.setUint8(3, byte1);
    packet.setUint8(4, byte2);
    packet.setUint8(5, byte3);
    packet.setUint8(6, byte4);
    packet.setUint8(7, PACKET_END);

    return packet.buffer.asUint8List();
  }

  static Uint8List createButtonPacket(int buttonNumber) {
    ByteData packet = ByteData(8);
    packet.setUint8(0, PACKET_START);
    packet.setUint8(1, EVENT_BUTTON);
    packet.setUint8(2, 4); // 데이터 길이 4바이트
    packet.setUint8(3, buttonNumber);
    packet.setUint8(4, 0);
    packet.setUint8(5, 0);
    packet.setUint8(6, 0);
    packet.setUint8(7, PACKET_END);

    return packet.buffer.asUint8List();
  }

  static Uint8List createTouchPacket(int x, int y) {
    ByteData packet = ByteData(8);
    packet.setUint8(0, PACKET_START);
    packet.setUint8(1, EVENT_TOUCH);
    packet.setUint8(2, 4); // 데이터 길이 4바이트
    packet.setUint16(3, x, Endian.big);
    packet.setUint16(5, y, Endian.big);
    packet.setUint8(7, PACKET_END);

    return packet.buffer.asUint8List();
  }

  static Uint8List createCommandPacket() {
    ByteData packet = ByteData(8);
    packet.setUint8(0, PACKET_START);
    packet.setUint8(1, EVENT_COMMAND);
    packet.setUint8(2, 4); // 데이터 길이 4바이트
    packet.setUint8(3, 0);
    packet.setUint8(4, 0);
    packet.setUint8(5, 0);
    packet.setUint8(6, 0);
    packet.setUint8(7, PACKET_END);

    return packet.buffer.asUint8List();
  }

  static Uint8List createCancelPacket() {
    ByteData packet = ByteData(8);
    packet.setUint8(0, PACKET_START);
    packet.setUint8(1, EVENT_CANCEL);
    packet.setUint8(2, 4); // 데이터 길이 4바이트
    packet.setUint8(3, 0);
    packet.setUint8(4, 0);
    packet.setUint8(5, 0);
    packet.setUint8(6, 0);
    packet.setUint8(7, PACKET_END);

    return packet.buffer.asUint8List();
  }

  static Uint8List createOFFPacket() {
    ByteData packet = ByteData(8);
    packet.setUint8(0, PACKET_START);
    packet.setUint8(1, EVENT_OFF);
    packet.setUint8(2, 4); // 데이터 길이 4바이트
    packet.setUint8(3, 0);
    packet.setUint8(4, 0);
    packet.setUint8(5, 0);
    packet.setUint8(6, 0);
    packet.setUint8(7, PACKET_END);

    return packet.buffer.asUint8List();
  }

  static Uint8List createelevateTouchPacket(int x, int y) {
    ByteData packet = ByteData(8);
    packet.setUint8(0, PACKET_START);
    packet.setUint8(1, EVENT_TOUCHELEVATE);
    packet.setUint8(2, 4); // 데이터 길이 4바이트
    packet.setUint16(3, x, Endian.big);
    packet.setUint16(5, y, Endian.big);
    packet.setUint8(7, PACKET_END);

    return packet.buffer.asUint8List();
  }

  static Uint8List createPressPacket() {
    ByteData packet = ByteData(8);
    packet.setUint8(0, PACKET_START);
    packet.setUint8(1, EVENT_PRESS);
    packet.setUint8(2, 4); // 데이터 길이 4바이트
    packet.setUint8(3, 0);
    packet.setUint8(4, 0);
    packet.setUint8(5, 0);
    packet.setUint8(6, 0);
    packet.setUint8(7, PACKET_END);

    return packet.buffer.asUint8List();
  }
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
    Future.delayed(const Duration(milliseconds: 2000), () {
      overlayEntry.remove();
    });
  }

  static void showOverlaybtnMessage(
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
    Future.delayed(const Duration(milliseconds: 50), () {
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

  static void showInputModalnum(
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
                  keyboardType: TextInputType.number,
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
  final TCPClient tcp = TCPClient();

  Offset? _touchPosition;
  String _touchPositionText = '';
  String _networkURL = "rtp://@:5000";
  //rtp://@:5000
  //http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4
  bool _isPlayerActive = true;

  CameraViewModel() {
    // TCP 연결 상태 변화 리스너 등록
    GlobalVariables.isTCPConnected.addListener(() {
      if (!GlobalVariables.isTCPConnected.value) {
        clearTouchPosition();
      }
    });
  }

  bool get isPlayerActive => _isPlayerActive;
  Offset? get touchPosition => _touchPosition;
  String get touchPositionText => _touchPositionText;
  String get networkURL => _networkURL;

  void cancelcoordinate() async {
    if (touchPosition != null) {
      clearTouchPosition();
      tcp.sendMessage(RobotCommand.createCancelPacket());
    }
  }

  void updateTouchPosition(Offset position, String text) {
    _touchPosition = position;
    _touchPositionText = text;
    notifyListeners();
  }

  void clearTouchPosition() {
    _touchPosition = null;
    _touchPositionText = '';
    SetRxData.itemName.value = '';
    notifyListeners();
  }

  void updateNetworkURL(String url) {
    _networkURL = url;
    notifyListeners();
  }

  void togglePlayerState() {
    _isPlayerActive = !_isPlayerActive;
    GlobalVariables.player.value = !GlobalVariables.player.value;
    notifyListeners();
  }

  void offPlayerState() {
    _isPlayerActive = false;
    GlobalVariables.player.value = false;
    notifyListeners();
  }
}

class wifiMonitor {
  final StreamController<bool> _wifiStreamController = StreamController<bool>();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  Stream<bool> get wifiStream => _wifiStreamController.stream;

  void startMonitoring() {
    // 기존 구독이 있으면 취소
    _connectivitySubscription?.cancel();

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      final isWifiConnected = result == ConnectivityResult.wifi;
      _wifiStreamController.add(isWifiConnected);
    });
  }

  void dispose() {
    _connectivitySubscription?.cancel(); // 구독 취소
    _wifiStreamController.close(); // 스트림 컨트롤러 닫기
  }
}
