import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:math';
import 'package:provider/provider.dart';

import './global.dart';
import 'menu_button.dart';
import './control_angle.dart';
import './control_view_translation.dart';
import 'triangle_button.dart';
import './camera_view.dart';
import './item_detail.dart';
import './pose_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진의 바인딩을 보장합니다.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CameraViewModel()),
      ],
      child: const MyApp(),
    ),
  ); // MyApp 위젯으로 앱을 시작합니다.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너를 숨깁니다.
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF2A2A2A), // 어두운 배경 색상으로 설정합니다.
      ),
      home: const Main(), // Main 위젯을 홈 화면으로 설정합니다.
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> with TickerProviderStateMixin {
  final currentDate = DateTime.now(); // 현재 날짜를 가져옵니다.
  late TimerMonitor _TimerMonitor;

  @override
  void initState() {
    super.initState();
    // 화면 방향을 가로로 설정합니다.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    // 시스템 UI 모드를 수동으로 설정하여 상단 UI만 표시합니다.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);

    _TimerMonitor = TimerMonitor();
    _TimerMonitor.startMonitoring();
    _TimerMonitor.wifiStream.listen((isConnected) {
      setState(() {
        GlobalVariables.isWifiConnected = isConnected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 화면 방향을 가로로 설정합니다.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    // 시스템 UI 모드를 엣지 투 엣지로 설정하여 상단 및 하단 UI를 표시합니다.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    final sizeHeight = MediaQuery.of(context).size.height; // 화면 높이
    final sizeWidth = MediaQuery.of(context).size.width; // 화면 너비

    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너를 숨깁니다.
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF2A2A2A), // 어두운 배경 색상으로 설정합니다.
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false, // 키보드가 화면을 가리지 않도록 설정합니다.
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF363535), // 전체 배경 색상 설정
          ),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5), // 컨테이너의 패딩 설정
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Row의 자식 위젯을 왼쪽으로 정렬
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Row의 자식 위젯을 위쪽으로 정렬
                children: [
                  // 왼쪽 버튼 부분
                  Expanded(
                    flex: 2, // 왼쪽 부분의 비율을 설정
                    child: Container(
                      margin:
                          const EdgeInsets.fromLTRB(0, 0, 10, 0), // 오른쪽 여백 설정
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.start, // Column의 자식 위젯을 위쪽으로 정렬
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Column의 자식 위젯을 왼쪽으로 정렬
                        children: [
                          // 버튼 4개
                          MenuButtonSection(
                            Size_Height: sizeHeight, // 화면 높이 전달
                            Size_Width: sizeWidth, // 화면 너비 전달
                          ),
                          // 카메라 앵글 조절
                          Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .start, // Row의 자식 위젯을 왼쪽으로 정렬
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3, // 오른쪽 부분의 비율을 설정
                                  child: PoseControls(
                                    Size_Height: sizeHeight, // 화면 높이 전달
                                    Size_Width: sizeWidth, // 화면 너비 전달
                                    buildTriangleButton:
                                        buildTriangleButton, // 삼각형 버튼 빌더 전달
                                  ),
                                ),
                                Expanded(
                                  flex: 7, // 왼쪽 부분의 비율을 설정
                                  child: CameraAngleControls(
                                    Size_Height: sizeHeight, // 화면 높이 전달
                                    Size_Width: sizeWidth, // 화면 너비 전달
                                    buildTriangleButton:
                                        buildTriangleButton, // 삼각형 버튼 빌더 전달
                                  ),
                                ),
                              ]),
                          // 카메라 뷰 조절
                          CameraViewTranslationControls(
                            Size_Height: sizeHeight, // 화면 높이 전달
                            Size_Width: sizeWidth, // 화면 너비 전달
                            buildTriangleButton:
                                buildTriangleButton, // 삼각형 버튼 빌더 전달
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 카메라 영상 & 데이터 출력 부분
                  Expanded(
                    flex: 3, // 오른쪽 부분의 비율을 설정
                    child: Container(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.start, // Column의 자식 위젯을 위쪽으로 정렬
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // Column의 자식 위젯을 중앙으로 정렬
                        children: [
                          // 카메라 영상
                          CameraView(Size_Height: sizeHeight), // 화면 높이 전달
                          // 아이템 세부 사항
                          ItemDetails(
                              Size_Height: sizeHeight, // 화면 높이 전달
                              Size_Width: sizeWidth), // 화면 너비 전달
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
