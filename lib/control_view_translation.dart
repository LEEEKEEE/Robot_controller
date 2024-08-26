import 'package:flutter/material.dart';

class CameraViewTranslationControls extends StatefulWidget {
  final double Size_Height;
  final double Size_Width;
  final Function _buildTriangleButton;

  const CameraViewTranslationControls({
    super.key,
    required this.Size_Height,
    required this.Size_Width,
    required Function buildTriangleButton,
  }) : _buildTriangleButton = buildTriangleButton;

  @override
  _CameraViewTranslationControlsState createState() =>
      _CameraViewTranslationControlsState();
}

class _CameraViewTranslationControlsState
    extends State<CameraViewTranslationControls> {
  double get sizeHeight => widget.Size_Height;
  double get sizeWidth => widget.Size_Width;
  Function get buildTriangleButton => widget._buildTriangleButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizeHeight * 0.37,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF454343),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Camera View Translation',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: sizeWidth * 0.02,
                  color: const Color(0xFFF3F3F3),
                ),
              ),
              SizedBox(width: sizeHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildTriangleButton(context, sizeHeight, 0.1, 0.15, true,
                          true, false, false, 6),
                      SizedBox(height: sizeHeight * 0.008),
                      SizedBox(height: sizeHeight * 0.008),
                      buildTriangleButton(context, sizeHeight, 0.1, 0.15, false,
                          false, true, true, 7),
                    ],
                  ),
                  SizedBox(width: sizeHeight * 0.05),
                  buildTriangleButton(context, sizeHeight, 0.15, 0.1, true,
                      false, true, false, 8),
                  SizedBox(width: sizeHeight * 0.008),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildTriangleButton(context, sizeHeight, 0.1, 0.15, true,
                          true, false, false, 9),
                      SizedBox(height: sizeHeight * 0.008),
                      Container(
                        width: sizeHeight * 0.08,
                        height: sizeHeight * 0.08,
                        decoration: BoxDecoration(
                          color: const Color(0xFF646667),
                          borderRadius:
                              BorderRadius.circular(sizeHeight * 0.08),
                        ),
                        child: Center(
                          child: GestureDetector(
                            child: Icon(
                              Icons.control_camera,
                              size: sizeHeight * 0.05,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sizeHeight * 0.008),
                      buildTriangleButton(context, sizeHeight, 0.1, 0.15, false,
                          false, true, true, 11),
                    ],
                  ),
                  SizedBox(width: sizeHeight * 0.008),
                  buildTriangleButton(context, sizeHeight, 0.15, 0.1, false,
                      true, false, true, 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
