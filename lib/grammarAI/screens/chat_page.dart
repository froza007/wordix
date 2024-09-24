
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wordix/grammarAI/widgets/custom_app_bar.dart';
import 'package:wordix/grammarAI/widgets/custom_button.dart';
import 'package:wordix/grammarAI/widgets/custom_text_input.dart';
import 'package:wordix/grammarAI/widgets/response_container.dart';
import 'package:wordix/grammarAI/widgets/suggestions_view.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();
  double heightContainer = 100;
  double heightRobot = 120;
  double heightSpace = 180;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Ai helper'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedContainer(
              margin: const EdgeInsets.only(top: 15),
              height: heightRobot,
              duration: const Duration(seconds: 1),
              child: Lottie.asset('assets/chat_robot.json',
                  width: 120, height: 120),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'How can I help you today',
              style: TextStyle(
                  fontSize: 23,
                  color: Color.fromARGB(207, 139, 139, 139),
                  fontWeight: FontWeight.w600),
            ),
            ResponseContainer(
                heightContainer: heightContainer, controller: controller),
            const SizedBox(
              height: 12,
            ),
            SuggestionsView(
              controller: controller,
              heightSpace: heightSpace,
            ),
            CustomTextInput(
              controller: controller,
              hint: 'Enter what you want here',
              suffIcon: Icons.close,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomButton(
                title: 'Search',
                onPressed: () {
                  if (controller.text == '') {
                    heightContainer = 100;
                    heightRobot = 120;
                    heightSpace = 180;
                    setState(() {});
                  } else {
                    heightContainer = 300;
                    heightRobot = 0;
                    heightSpace = 50;
                    setState(() {});
                  }
                }),
          ],
        ),
      ),
    );
  }
}
