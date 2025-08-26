import 'package:flutter/material.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class WoodlabsSlider extends StatefulWidget {
  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;
  final String label;
  final String unit;

  const WoodlabsSlider({
    super.key,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
    required this.label,
    this.unit = "s",
  });

  @override
  State<StatefulWidget> createState() => _WoodlabsSliderState();
}

class _WoodlabsSliderState extends State<WoodlabsSlider> {
  late double sliderValue;

  @override
  void initState() {
    sliderValue = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: context.customTextStyles.label),
        SizedBox(height: 4.0),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 32,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: context.customColors.backgroundLight,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: context.customColors.attmayGreen,
                          ),
                        ),
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double width = constraints.maxWidth;

                        final double sliderPosition =
                            ((sliderValue - widget.min) /
                                (widget.max - widget.min)) *
                            width;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Container(
                            height: 30,
                            width: sliderPosition,
                            decoration: BoxDecoration(
                              color: context.customColors.attmayGreen,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        );
                      },
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        overlayShape: SliderComponentShape.noOverlay,
                        trackHeight: 30,
                        thumbShape: _WoodlabsSliderThumbShape(),
                        trackShape: _WoodlabsSliderTrackShape(),
                        thumbColor: context.customColors.white100,
                      ),
                      child: Slider(
                        min: widget.min,
                        max: widget.max,
                        value: sliderValue,
                        onChanged: _onSliderChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16.0),
            SizedBox(
              width: 40,
              child: Text(
                "${sliderValue.round().toString()}${widget.unit}",
                style: context.customTextStyles.bodyRegular,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onSliderChanged(double value) {
    setState(() {
      sliderValue = value;
    });
    widget.onChanged(value);
  }
}

class _WoodlabsSliderThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(14, 32);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Paint paint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.white
      ..style = PaintingStyle.fill;

    final Rect thumbRect = Rect.fromCenter(
      center: center,
      width: 14,
      height: 32,
    );

    final RRect thumbRRect = RRect.fromRectAndRadius(
      thumbRect,
      Radius.circular(4.0),
    );

    canvas.drawRRect(thumbRRect, paint);
  }
}

class _WoodlabsSliderTrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = true,
    bool isDiscrete = false,
  }) {
    final double trackHeight = 32.0;
    final double trackWidth = parentBox.size.width;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = true,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final Canvas canvas = context.canvas;

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      offset: offset,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint activePaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
  }
}
