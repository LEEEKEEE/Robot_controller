import 'package:flutter/material.dart';

class CameraAngleControls extends StatefulWidget {
  final double Size_Height;
  final double Size_Width;
  final Function _buildTriangleButton;

  const CameraAngleControls({
    super.key,
    required this.Size_Height,
    required this.Size_Width,
    required Function buildTriangleButton,
  }) : _buildTriangleButton = buildTriangleButton;

  @override
  _CameraAngleControlsState createState() => _CameraAngleControlsState();
}

class _CameraAngleControlsState extends State<CameraAngleControls> {
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
                'Camera Angle',
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
                  buildTriangleButton(
                    context,
                    sizeHeight,
                    0.15,
                    0.1,
                    true,
                    false,
                    true,
                    false,
                    0,
                  ),
                  SizedBox(width: sizeHeight * 0.008),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildTriangleButton(
                        context,
                        sizeHeight,
                        0.1,
                        0.15,
                        true,
                        true,
                        false,
                        false,
                        1,
                      ),
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
                              Icons.cached,
                              size: sizeHeight * 0.05,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sizeHeight * 0.008),
                      buildTriangleButton(
                        context,
                        sizeHeight,
                        0.1,
                        0.15,
                        false,
                        false,
                        true,
                        true,
                        3,
                      ),
                    ],
                  ),
                  SizedBox(width: sizeHeight * 0.008),
                  buildTriangleButton(
                    context,
                    sizeHeight,
                    0.15,
                    0.1,
                    false,
                    true,
                    false,
                    true,
                    2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
