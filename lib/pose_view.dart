import 'package:flutter/material.dart';

class PoseControls extends StatefulWidget {
  final double Size_Height;
  final double Size_Width;
  final Function _buildTriangleButton;

  const PoseControls({
    super.key,
    required this.Size_Height,
    required this.Size_Width,
    required Function buildTriangleButton,
  }) : _buildTriangleButton = buildTriangleButton;

  @override
  _PoseControlsState createState() => _PoseControlsState();
}

class _PoseControlsState extends State<PoseControls> {
  double get sizeHeight => widget.Size_Height;
  double get sizeWidth => widget.Size_Width;
  Function get buildTriangleButton => widget._buildTriangleButton;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: sizeHeight * 0.37,
        margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF454343),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Pose',
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
                      buildTriangleButton(
                        context,
                        sizeHeight,
                        0.14,
                        0.14,
                        false,
                        false,
                        false,
                        false,
                        0,
                      ),
                      SizedBox(height: sizeHeight * 0.015),
                      buildTriangleButton(
                        context,
                        sizeHeight,
                        0.14,
                        0.14,
                        false,
                        false,
                        false,
                        false,
                        1,
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ));
  }
}
