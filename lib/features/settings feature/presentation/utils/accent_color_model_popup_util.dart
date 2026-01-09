import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_bloc.dart';
import 'package:chatbot_ai/core/bloc/accent%20color%20SP%20bloc/accent_color_event.dart';
import 'package:chatbot_ai/core/services/shared_preferences_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showSheet(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    builder: (_) => SafeArea(
      child: CupertinoActionSheet(
        title: Text('Accent colors'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              context.read<AccentColorBloc>().add(
                SetColorEvent(
                  key: SharedPreferencesKEYS.accentColorKey,
                  value: '⚪️  Default',
                ),
              );
              Navigator.pop(context);
            },
            child: _centerAlign('⚪️  Default'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              context.read<AccentColorBloc>().add(
                SetColorEvent(
                  key: SharedPreferencesKEYS.accentColorKey,
                  value: '🔴  Red',
                ),
              );
              Navigator.pop(context);
            },
            child: _centerAlign('🔴  Red'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              context.read<AccentColorBloc>().add(
                SetColorEvent(
                  key: SharedPreferencesKEYS.accentColorKey,
                  value: '🟢  Green',
                ),
              );
              Navigator.pop(context);
            },
            child: _centerAlign('🟢  Green'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              context.read<AccentColorBloc>().add(
                SetColorEvent(
                  key: SharedPreferencesKEYS.accentColorKey,
                  value: '🔵  Blue',
                ),
              );
              Navigator.pop(context);
            },
            child: _centerAlign('🔵  Blue'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              context.read<AccentColorBloc>().add(
                SetColorEvent(
                  key: SharedPreferencesKEYS.accentColorKey,
                  value: '🟡  Yellow',
                ),
              );
              Navigator.pop(context);
            },
            child: _centerAlign('🟡  Yellow'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    ),
  );
}

Widget _centerAlign(String text) {
  return Container(
    color: CupertinoColors.transparent,
    width: double.infinity,
    height: 30,
    child: Row(
      mainAxisAlignment: .start,
      crossAxisAlignment: .start,
      children: [Text(text, maxLines: 1)],
    ),
  );
}
