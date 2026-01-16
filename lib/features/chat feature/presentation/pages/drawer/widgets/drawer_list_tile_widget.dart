import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20bloc/chat_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20ID%20pref%20bloc/chat_room_id_pref_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20ID%20pref%20bloc/chat_room_id_pref_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/new%20chat%20pref%20bloc/new_chat_pref_bloc.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/new%20chat%20pref%20bloc/new_chat_pref_event.dart';
import 'package:cupertino_sidemenu/cupertino_sidemenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerListTileWidget extends StatelessWidget {
  const DrawerListTileWidget({
    super.key,
    required this.currentId,
    required this.chatRoomEntity,

    required this.advancedDrawerController,
  });
  final int currentId;
  final ChatRoomEntity chatRoomEntity;
  final CupertinoSidemenuController advancedDrawerController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (currentId == chatRoomEntity.id)
            ? CupertinoColors.inactiveGray.withAlpha(50)
            : null,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: CupertinoListTile(
        onTap: () async {
          advancedDrawerController.closeMenu();

          context.read<ChatRoomIdPrefBloc>().add(
            SetChatRoomIdPrefEvent(value: chatRoomEntity.id),
          );
          context.read<NewChatPrefBloc>().add(
            SetNewChatboolPrefEvent(value: false),
          );

          context.read<ChatBloc>().add(GetChatsEvent());
        },

        title: Text(chatRoomEntity.title),
        trailing: chatRoomEntity.isPin
            ? Icon(CupertinoIcons.pin, size: 20)
            : null,
      ),
    );
  }
}
