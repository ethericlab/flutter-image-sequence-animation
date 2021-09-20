import 'package:flutter/material.dart';

const divisionsCount = 16;
const divisionWidth = 3.0;
const mainDivisionWidth = 4.0;
const spaceBetweenDivisions = 40.0;
const divisionMaxHeight = 70.0;

const distanceFromCenterToStartTransform = 120.0;

class AmountSlider extends StatefulWidget {
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;

  const AmountSlider({
    Key? key,
    required this.onChanged,
    required this.min,
    required this.max,
  }) : super(key: key);

  @override
  _AmountSliderState createState() => _AmountSliderState();
}

class _AmountSliderState extends State<AmountSlider> {
  late double screenWidth;
  final scrollController = ScrollController();

  get xMiddleScreen => screenWidth / 2;

  get scrollWidth => ((divisionsCount - 1) * divisionWidth +
      (divisionsCount - 1) * spaceBetweenDivisions);

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {
        if (widget.onChanged != null) {
          if (scrollController.offset <= 0) {
            widget.onChanged!(widget.min);
            return;
          }
          if (scrollController.offset >= scrollWidth) {
            widget.onChanged!(widget.max);
            return;
          }
          final sliderValue =
              ((scrollController.offset.round()) / scrollWidth * widget.max);
          widget.onChanged!(sliderValue);
        }
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Stack(
          children: [
            Container(
              height: divisionMaxHeight,
              child: ListView.separated(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: spaceBetweenDivisions),
                itemCount: divisionsCount + 2,
                itemBuilder: (context, index) {
                  if (index == 0 || index == divisionsCount + 1) {
                    return SizedBox(
                      width: xMiddleScreen -
                          spaceBetweenDivisions -
                          (mainDivisionWidth / 2),
                    );
                  }
                  return AnimatedContainer(
                    margin: EdgeInsets.symmetric(
                      vertical: calculateDivisionPadding(index),
                    ),
                    width: calculateDivisionWidth(index),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: const Color(0x80FFFFFF),
                    ),
                    duration: const Duration(microseconds: 100),
                  );
                },
              ),
            ),
          ],
        ),
        Container(
          height: divisionMaxHeight,
          width: mainDivisionWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.white,
          ),
        )
      ],
    );
  }

  double calculateDivisionPadding(int itemIndex) {
    final normalMargin = (divisionMaxHeight - 10) / 2;
    final itemDistanceToCenter = calculateDistanceToCenter(itemIndex).abs();
    if (itemDistanceToCenter > distanceFromCenterToStartTransform) {
      return normalMargin;
    } else {
      final margin = itemDistanceToCenter /
          distanceFromCenterToStartTransform *
          normalMargin;
      return margin;
    }
  }

  double calculateDistanceToCenter(int itemIndex) {
    final scrollPosition = scrollController.position.pixels;
    final divisionsWidth = itemIndex * divisionWidth;
    final itemStartPosition =
        (divisionsWidth + itemIndex * spaceBetweenDivisions) +
            (xMiddleScreen - spaceBetweenDivisions - (divisionWidth / 2));
    if (itemStartPosition < scrollPosition) {
      return xMiddleScreen - itemStartPosition - scrollPosition;
    } else {
      return xMiddleScreen - itemStartPosition + scrollPosition;
    }
  }

  double calculateDivisionWidth(int itemIndex) {
    final itemDistanceToCenter = calculateDistanceToCenter(itemIndex);
    if (itemDistanceToCenter >= -40 - mainDivisionWidth / 2 &&
        itemDistanceToCenter < 0) {
      return mainDivisionWidth;
    } else if (itemDistanceToCenter <= 40 + mainDivisionWidth / 2 &&
        itemDistanceToCenter > 0) {
      return mainDivisionWidth;
    }
    return divisionWidth;
  }
}
