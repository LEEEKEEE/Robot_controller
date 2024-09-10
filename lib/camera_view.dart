import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:provider/provider.dart';

import './global.dart';
import './TCPClient.dart';

class CameraView extends StatefulWidget {
  final double Size_Height;

  const CameraView({super.key, required this.Size_Height});

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late VlcPlayerController? _vlcController;
  final TCPClient tcp = TCPClient();

  String _previousNetworkURL = "rtp://@:5000";

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = Provider.of<CameraViewModel>(context);

    if (viewModel.isPlayerActive && _vlcController == null) {
      _initializePlayer();
    } else if (!viewModel.isPlayerActive && _vlcController != null) {
      _disposePlayer();
    }

    // Check if the network URL has changed
    if (viewModel.networkURL != _previousNetworkURL) {
      _vlcController?.pause();

      _setMediaFromNetwork(viewModel.networkURL); // 변경된 네트워크 URL로 미디어 설정

      _previousNetworkURL = viewModel.networkURL;
    }
  }

  @override
  void dispose() {
    _vlcController?.dispose();
    super.dispose();
  }

  void _disposePlayer() {
    _vlcController?.dispose();
    _vlcController = null;
  }

  void _initializePlayer() {
    final viewModel = Provider.of<CameraViewModel>(context, listen: false);

    if (viewModel.networkURL.isEmpty) return;

    _vlcController = VlcPlayerController.network(
      viewModel.networkURL,
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(300),
          VlcAdvancedOptions.liveCaching(200),
          VlcAdvancedOptions.fileCaching(200),
          VlcAdvancedOptions.clockSynchronization(0), // 클럭 동기화 비활성화
          VlcAdvancedOptions.clockJitter(0), // 클럭 지터 제거
        ]),
        audio: VlcAudioOptions([
          VlcAudioOptions.audioTimeStretch(false),
        ]),
        video: VlcVideoOptions([
          VlcVideoOptions.dropLateFrames(true),
          VlcVideoOptions.skipFrames(true), // 프레임 건너뛰기 활성화
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    );
  }

  Future<void> _setMediaFromNetwork(String url) async {
    await _vlcController?.setMediaFromNetwork(
      url,
      autoPlay: true,
      hwAcc: HwAcc.full,
    );
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
      if (!vlcProvider.isPlayerActive || _vlcController == null) {
        return Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                    height: widget.Size_Height * 0.65,
                    padding: const EdgeInsets.all(5),
                    child: const Center(
                      child: Text('Player is inactivated'),
                    ),
                  ),
                )));
      }
      return GestureDetector(
        onTapUp: _handleTap,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                            height: widget.Size_Height * 0.65,
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: VlcPlayer(
                                    controller: _vlcController!,
                                    aspectRatio: 16 / 9,
                                    placeholder: const Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                )
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
        ),
      );
    });
  }
}
