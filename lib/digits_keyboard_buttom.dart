import 'package:flutter/material.dart';

class DigitsKeyboardButton extends StatelessWidget {
  const DigitsKeyboardButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0xFF856EE1),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.all(23),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(width: 2, color: const Color(0xFF9A88E6))
          ),
        ),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.5,
          mainAxisSpacing: 4.5,
          mainAxisExtent: 5,
          childAspectRatio: 1
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          if (index == 6 || index == 8) {
            return Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: const Color(0x4DFFFFFF),
              ),
            );
          }
          return Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
