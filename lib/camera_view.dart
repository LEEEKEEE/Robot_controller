import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import './global.dart';
import './TCPClient.dart';

class CameraView extends StatefulWidget {
  final double Size_Height; // 위젯의 높이를 설정하는 변수
  final double Size_Width; // 위젯의 너비를 설정하는 변수
  const CameraView(
      {super.key, required this.Size_Height, required this.Size_Width});

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
//  late VlcPlayerController? _vlcController;
  final TCPClient tcp = TCPClient();
  static const platform =
      MethodChannel('com.example.robotarm_controller/vlc_player');

  @override
  void initState() {
    super.initState();
    _initializedPlayer();
    WidgetsBinding.instance.addObserver(this); // 생명주기 이벤트 감지 추가
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 생명주기 이벤트 감지 제거
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 앱이 포그라운드로 돌아왔을 때 VLC 플레이어 재초기화
      Provider.of<CameraViewModel>(context, listen: false).offPlayerState();
    }
  }

  Future<void> _initializedPlayer() async {
    try {
      await platform.invokeMethod('initializePlayer');
    } on PlatformException catch (e) {
      print("플레이어 초기화 실패: '${e.message}'.");
    }
  }

  void _handleTap(TapUpDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localOffset = renderBox.globalToLocal(details.globalPosition);

    const int centerX = 640;
    const int centerY = 360;

    final double dataDx = (localOffset.dx / renderBox.size.width) * 1280;
    final double dataDy = (localOffset.dy / renderBox.size.height) * 720;

    final int intDataDx = dataDx.toInt();
    final int intDataDy = dataDy.toInt();

    final int dx = intDataDx - centerX;
    final int dy = centerY - intDataDy;

    final viewModel = Provider.of<CameraViewModel>(context, listen: false);

    viewModel.updateTouchPosition(localOffset, 'x: $dx, y: $dy');

    tcp.sendMessage(RobotCommand.createTouchPacket(intDataDx, intDataDy));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CameraViewModel>(context);
    return Consumer<CameraViewModel>(builder: (context, vlcProvider, child) {
      if (!vlcProvider.isPlayerActive) {
        return Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9).withOpacity(0.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000),
                          offset: Offset(0, 4),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    height: widget.Size_Width * 0.3375,
                    padding: const EdgeInsets.all(5),
                    child: const Center(
                      child: Text('Player is inactivated'),
                    ),
                  ),
                )));
      }

      return Stack(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: ValueListenableBuilder<bool>(
                      valueListenable: SetRxData.angleError,
                      builder: (context, angleError, _) {
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9).withOpacity(0.5),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x40000000),
                                offset: Offset(0, 4),
                                blurRadius: 2,
                              ),
                            ],
                            border: Border.all(
                              color: angleError
                                  ? Colors.transparent
                                  : Colors.red, // 테두리 색 설정
                              width: 2.0, // 테두리 두께 설정
                            ),
                          ),
                          height: widget.Size_Width * 0.3375,
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Stack(children: [
                                AndroidView(
                                  viewType:
                                      'com.example.robotarm_controller/vlc_player_view',
                                  creationParams: <String, dynamic>{
                                    'url': vlcProvider.networkURL,
                                  },
                                  creationParamsCodec:
                                      const StandardMessageCodec(),
                                ),
                                GestureDetector(
                                  onTapUp: _handleTap,
                                  child: Container(
                                    color: Colors
                                        .transparent, // 투명한 Container로 제스처 감지
                                  ),
                                ),
                              ]))
                            ],
                          ),
                        );
                      })),
            ),
          ),
          if (viewModel.touchPosition != null)
            Positioned(
              left: viewModel.touchPosition!.dx - 50,
              top: viewModel.touchPosition!.dy - 80,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 58, 58, 58),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  viewModel.touchPositionText,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      );
    });
  }
}
