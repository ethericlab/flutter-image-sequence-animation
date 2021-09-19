import 'dart:math' as math;

import 'package:flutter/material.dart';

const divisionsCount = 16;
const divisionWidth = 2.0;
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
          if (scrollController.offset < 0) {
            widget.onChanged!(widget.min);
            return;
          }
          if (scrollController.offset > scrollWidth) {
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
                      width: xMiddleScreen - spaceBetweenDivisions - (divisionWidth / 2),
                    );
                  }
                  return AnimatedContainer(
                    margin: EdgeInsets.symmetric(
                      vertical: calculateDivisionPadding(
                        scrollController.position.pixels,
                        index,
                      ),
                    ),
                    width: divisionWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.grey,
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
          width: divisionWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.white,
          ),
        )
      ],
    );
  }

  double calculateDivisionPadding(double scrollPosition, int itemIndex) {
    final newItemIndex = itemIndex + 1;
    final itemStartPosition = (newItemIndex * divisionWidth +
            (newItemIndex - 1) * spaceBetweenDivisions) +
        xMiddleScreen -
        spaceBetweenDivisions;
    var itemDistanceToCenter;
    if (itemStartPosition < scrollPosition) {
      itemDistanceToCenter =
          (xMiddleScreen - itemStartPosition - scrollPosition).abs();
    } else {
      itemDistanceToCenter =
          (xMiddleScreen - itemStartPosition + scrollPosition).abs();
    }

    final normalMargin = (divisionMaxHeight - 10) / 2;

    if (itemDistanceToCenter > distanceFromCenterToStartTransform) {
      return normalMargin;
    } else {
      final marginSqrt = math.sqrt(itemDistanceToCenter) /
          math.sqrt(distanceFromCenterToStartTransform) *
          math.sqrt(normalMargin);
      return marginSqrt * marginSqrt;
    }
  }
}
