import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:provider/provider.dart';

import './global.dart';

class CameraView extends StatefulWidget {
  final double Size_Height;

  const CameraView({super.key, required this.Size_Height});

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late VlcPlayerController _vlcController;
  String _previousNetworkURL =
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = Provider.of<CameraViewModel>(context);

    // Check if the network URL has changed
    if (viewModel.networkURL != _previousNetworkURL) {
      _vlcController.pause();

      _setMediaFromNetwork(viewModel.networkURL); // 변경된 네트워크 URL로 미디어 설정

      _previousNetworkURL = viewModel.networkURL;
    }
  }

  @override
  void dispose() {
    _vlcController.dispose();
    super.dispose();
  }

  void _initializePlayer() {
    final viewModel = Provider.of<CameraViewModel>(context, listen: false);

    if (viewModel.networkURL.isEmpty) return;

    _vlcController = VlcPlayerController.network(
      viewModel.networkURL,
      hwAcc: HwAcc.full,
      autoPlay: false,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(1000),
        ]),
      ),
    );
  }

  Future<void> _setMediaFromNetwork(String url) async {
    await _vlcController.setMediaFromNetwork(
      url,
      autoPlay: true,
      hwAcc: HwAcc.full,
    );
  }

  void _handleTap(TapUpDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localOffset = renderBox.globalToLocal(details.globalPosition);

    final double centerX = renderBox.size.width / 2;
    final double centerY = renderBox.size.height / 2;

    final double dx = localOffset.dx - centerX;
    final double dy = centerY - localOffset.dy;

    final String formattedDx = dx.toStringAsFixed(1);
    final String formattedDy = dy.toStringAsFixed(1);

    final viewModel = Provider.of<CameraViewModel>(context, listen: false);

    viewModel.updateTouchPosition(
        localOffset, 'x: $formattedDx, y: $formattedDy');
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CameraViewModel>(context);

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: VlcPlayer(
                          controller: _vlcController,
                          aspectRatio: 16 / 9,
                          placeholder:
                              const Center(child: CircularProgressIndicator()),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (viewModel.touchPosition != null)
            Positioned(
              left: viewModel.touchPosition!.dx - 70,
              top: viewModel.touchPosition!.dy - 50,
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
  }
}
