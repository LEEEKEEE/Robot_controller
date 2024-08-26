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
import './TCPClient.dart';

class GlobalVariables {
  static bool Screen_Off = false;
  static int txtimer_duration = 50;
  static int rxtimer_duration = 50;
  static String Item_name = "";
  static String test_string = "Hi!!";
  static String btdevice_adress = "";
  static double Item_X = 0.0;
  static double Item_Y = 0.0;
  static double Item_Z = 0.0;
  static ValueNotifier<bool> communityConnect = ValueNotifier<bool>(false);
  static ValueNotifier<bool> armError = ValueNotifier<bool>(false);
  static bool isWifiConnected = false;
  static bool isURLConnected = false;
  static bool isBTConnected = false;
  static ValueNotifier<bool> isTCPConnected = ValueNotifier<bool>(false);
  static ValueNotifier<bool> isUDPConnected = ValueNotifier<bool>(false);
  static String Network_URL = "";
  static String PADIp = "";
  static int PADPort = 0;
  static String TargetIp = "";
  static int TargetPort = 0;
  static String serverIp = "";
  static int serverPort = 0;

  static DateTime nowDateTime = DateTime.now();
  static DateTime sendDateTime = DateTime.now();
  static DateTime reavDateTime = DateTime.now();
}

class SetTxData {
  static List<int> TxData = List<int>.filled(15, 0);
  static List<int> TxDatatest = List<int>.filled(2, 0);
  // static List<int> TxData = List<int>.filled(27, 0);
  static int Event_Type = 0;
  static int Button_num = 0;
  static int Msg2_SBW_Cmd_Tx = 0;
  static int Accel_Pedal_Angle = 0;
  static int Button_Pedal = 0;
  static int Joystick_Input_Left_X = 0;
  static int Joystick_Input_Left_Y = 0;
  static int Joystick_Input_Right_X = 0;
  static int Joystick_Input_Right_Y = 0;
  static int Drive_Mode_Switch = 0;
  static bool Flag_Pivot = false;
  static int Flag_Pivot_Num = 0;
  static int Pivot_Rcx = 0;
  static int Pivot_Rcy = 0;
  static int Accel_X = 0;
  static int Accel_Y = 0;
  static int Accel_Z = 0;
  static int Gyro_Y = 0;
  static int Gyro_P = 0;
  static int Gyro_R = 0;
}

class SetRxData {
  static List<int> RxData = List<int>.filled(38, 0);

  static int Corner_Mode = 0;
  static int Mode_Disable_Button_Blink = 0;
  static int Corner_Mode_Disable_Button = 0;
  static int Measured_Steer_Angle_Fl = 0;
  static int Target_Steer_Current_Fl = 0;
  static int Measured_Steer_Current_Fl = 0;
  static int Measured_Steer_Angle_Fr = 0;
  static int Target_Steer_Current_Fr = 0;
  static int Measured_Steer_Current_Fr = 0;
  static int Measured_Steer_Angle_Rl = 0;
  static int Target_Steer_Current_Rl = 0;
  static int Measured_Steer_Current_Rl = 0;
  static int Measured_Steer_Angle_Rr = 0;
  static int Target_Steer_Current_Rr = 0;
  static int Measured_Steer_Current_Rr = 0;
  static int Vehicle_Speed = 0;
  static int Battery_Soc = 0;
}

class RobotCommand {
  static const int PACKET_START = 0xAA;
  static const int PACKET_END = 0xDD;

  static const int EVENT_BUTTON = 0x01;
  static const int EVENT_TOUCH = 0x02;

  static Uint8List createButtonPacket(int buttonNumber) {
    if (buttonNumber < 1 || buttonNumber > 13) {
      throw ArgumentError('Button number must be between 1 and 13');
    }

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

  static Uint8List createTouchPacket(double x, double y) {
    ByteData packet = ByteData(8);
    packet.setUint8(0, PACKET_START);
    packet.setUint8(1, EVENT_TOUCH);
    packet.setUint8(2, 4); // 데이터 길이 4바이트

    // x와 y 좌표를 각각 2바이트 정수로 변환 (0-65535 범위)
    int xInt = (x * 65535).round().clamp(0, 65535);
    int yInt = (y * 65535).round().clamp(0, 65535);

    packet.setUint16(3, xInt, Endian.big);
    packet.setUint16(5, yInt, Endian.big);
    packet.setUint8(7, PACKET_END);

    return packet.buffer.asUint8List();
  }
}

// 사용 예시
//void main() {
// 버튼 5 누름
//  var buttonPacket = RobotCommand.createButtonPacket(5);
//  print('Button Packet: ${buttonPacket.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}');

// 터치 좌표 전송 (x: 0.5, y: 0.75)
//  var touchPacket = RobotCommand.createTouchPacket(0.5, 0.75);
//  print('Touch Packet: ${touchPacket.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}');
//}

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
    Future.delayed(const Duration(milliseconds: 150), () {
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
  Offset? _touchPosition;
  String _touchPositionText = '';
  String _networkURL =
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

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

class TimerMonitor {
  final StreamController<bool> _wifiStreamController = StreamController<bool>();
  Stream<bool> get wifiStream => _wifiStreamController.stream;
  final TCPClient tcp = TCPClient();

  void startMonitoring() {
    Timer.periodic(const Duration(milliseconds: 10), (timer) async {
      // Date & Time
      GlobalVariables.nowDateTime = DateTime.now();
    });
    Timer.periodic(const Duration(milliseconds: 50), (timer) async {
      // Check Wifi
      final connectivityResult = await Connectivity().checkConnectivity();
      final isWifiConnected = connectivityResult == ConnectivityResult.wifi;
      _wifiStreamController.add(isWifiConnected);
    });
    Timer.periodic(const Duration(milliseconds: 10), (timer) async {
      if (DateTime.now()
              .difference(GlobalVariables.sendDateTime)
              .inMilliseconds >=
          GlobalVariables.txtimer_duration) {
        GlobalVariables.sendDateTime = DateTime.now();
      }

      if (DateTime.now()
              .difference(GlobalVariables.reavDateTime)
              .inMilliseconds >=
          GlobalVariables.rxtimer_duration) {
        GlobalVariables.reavDateTime = DateTime.now();
      }
    });
  }

  void dispose() {
    _wifiStreamController.close();
  }
}
