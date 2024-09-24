import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;

  const CustomButton({super.key, required this.title, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 47,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          enableFeedback: true,
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          backgroundColor:
              const WidgetStatePropertyAll(Colors.deepPurpleAccent),
          elevation: WidgetStateProperty.all(0),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
