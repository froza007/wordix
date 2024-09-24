import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomLangButton extends StatelessWidget {
  String lang;
  Function showBottomSheet;
  final int numButton;
  CustomLangButton(
      {super.key, required this.lang, required this.showBottomSheet,required this.numButton});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(25))),
          textStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 17.2, fontWeight: FontWeight.w500)),
          fixedSize: const WidgetStatePropertyAll(Size(140, 50)),
          enableFeedback: true,
          foregroundColor: const WidgetStatePropertyAll(Color(0xFFFFFFFF)),
          backgroundColor:
              const WidgetStatePropertyAll(Colors.deepPurpleAccent),
          elevation: WidgetStateProperty.all(0),
        ),
        onPressed: () {
          showBottomSheet(numButton : numButton);
        },
        child: Text(lang));
  }
}
