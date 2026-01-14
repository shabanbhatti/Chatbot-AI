import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/delete_chat_room_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/get_chat_rooms_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/insert_chat_room_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/domain/usecases/update_chat_room_usecase.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20bloc/chat_room_event.dart';
import 'package:chatbot_ai/features/chat%20feature/presentation/bloc/chat%20room%20bloc/chat_room_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final GetChatRoomsUsecase getChatRoomsUsecase;
  final InsertChatRoomUsecase insertChatRoomUsecase;
  final UpdateChatRoomUsecase updateChatRoomUsecase;
  final DeleteChatRoomUsecase deleteChatRoomUsecase;
  ChatRoomBloc({
    required this.getChatRoomsUsecase,
    required this.insertChatRoomUsecase,
    required this.deleteChatRoomUsecase,
    required this.updateChatRoomUsecase,
  }) : super(InitialChatRoom()) {
    on<GetChatRoomsEvent>((event, emit) async {
      try {
        emit(LoadingChatRoom());
        var data = await getChatRoomsUsecase();
        var pinnedRooms = data.where((element) => element.isPin).toList();
        var unPinRooms = data.where((element) => !element.isPin).toList();

        emit(LoadedChatRoom(chatRoomEntities: [...unPinRooms, ...pinnedRooms]));
      } on Failures catch (e) {
        emit(ErrorChatRoom(message: e.message));
      }
    });
    on<CreateFirstChatRoomEvent>((event, emit) async {
      try {
        var data = await getChatRoomsUsecase();
        for (var element in data) {
          if (element.title.isEmpty) {
            await deleteChatRoomUsecase(element.id);
          }
        }
        await insertChatRoomUsecase(event.chatRoomEntity);

        emit(CreatedFirstTimeChatRoom(id: event.chatRoomEntity.id));
      } on Failures catch (e) {
        emit(ErrorChatRoom(message: e.message));
      }
    });

    on<CreateChatRoomEvent>((event, emit) async {
      try {
        await insertChatRoomUsecase(event.chatRoomEntity);

        emit(CreatedChatRoom(id: event.chatRoomEntity.id));
      } on Failures catch (e) {
        emit(ErrorChatRoom(message: e.message));
      }
    });

    on<UpdateChatRoomEvent>((event, emit) async {
      await updateChatRoomUsecase(event.chatRoomEntity);
      var loaded = state as LoadedChatRoom;
      final updatedList = loaded.chatRoomEntities
          .map(
            (e) => (e.id == event.chatRoomEntity.id)
                ? e.copyWith(
                    title: event.chatRoomEntity.title,
                    isTitleAssigned: event.chatRoomEntity.isTitleAssigned,
                  )
                : e,
          )
          .toList();

      emit(LoadedChatRoom(chatRoomEntities: updatedList));
    });
    on<SearchOnChangedEvent>((event, emit) async {
      if (event.query.isNotEmpty) {
        var loaded = state as LoadedChatRoom;
        var list = loaded.chatRoomEntities
            .where(
              (element) => element.title.toLowerCase().contains(
                event.query.toLowerCase().trim(),
              ),
            )
            .toList();
        emit(LoadedChatRoom(chatRoomEntities: list));
      } else {
        add(GetChatRoomsEvent());
      }
    });

    on<DeleteChatRoomEvent>((event, emit) async {
      await deleteChatRoomUsecase(event.id);
      emit(DeletedChatRoom());
    });

    on<PinOrUnpinChatRoomEvent>((event, emit) async {
      await updateChatRoomUsecase(event.chatRoomEntity);
      add(GetChatRoomsEvent());
    });
  }
}
