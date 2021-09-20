import 'package:flutter/material.dart';

class DoneButton extends StatelessWidget {
  const DoneButton({Key? key, required this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          foregroundColor: MaterialStateProperty.all<Color>(
            const Color(0xFF856EE1),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.all(27),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        child: Text(
          'Done',
          style: const TextStyle(
            fontFamily: 'Averta',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
