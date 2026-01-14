import 'package:chatbot_ai/core/typedefs/typedefs.dart';
import 'package:flutter/cupertino.dart';

void showDeleteSheetInChatRoom(
  BuildContext context, {
  required OnPressed onDelete,
  required OnPressed onPin,
  required bool isPin,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        title: const Text('Choose Option'),
        message: const Text('Want to delete or pin?'),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              onPin();
            },
            child: Text(
              !isPin ? 'Pin' : 'Unpin',
              style: CupertinoTheme.of(
                context,
              ).textTheme.textStyle.copyWith(fontSize: 20),
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: const Text('Delete'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      );
    },
  );
}
