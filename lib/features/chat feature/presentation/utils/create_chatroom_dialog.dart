import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:chatbot_ai/core/widgets/custom%20textfields/custom_basic_textfield.dart';
import 'package:flutter/cupertino.dart';

void showDialog(
  BuildContext context,
  TextEditingController controller, {
  required OnPressed onCreate,
}) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: const Text('Create chat'),
        content: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsetsGeometry.only(top: 15),
                child: CustomBasicTextfield(
                  controller: controller,
                  placeHolderSize: 12,
                  title: "What you're gonna talk about?",
                ),
              ),
            ),
          ],
        ),
        actions: [
          CupertinoButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoButton(onPressed: onCreate, child: Text('Create')),
        ],
      );
    },
  );
}
