import 'package:chatbot_ai/core/shared%20domain/entity/chat_bckgnd_img_path_entity.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/delete_user_usecase.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/get_user_usecase.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/insert_chat_bckgnd_img_paths_usecae.dart';
import 'package:chatbot_ai/core/shared%20domain/usecases/insert_user_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserUsecase getUserUsecase;
  final InsertUserUsecase insertUserUsecase;
  final DeleteUserUsecase deleteUserUsecase;
  final InsertChatBckgndImgPathsUsecae insertChatBckgndImgPathsUsecae;

  UserBloc({
    required this.getUserUsecase,
    required this.insertUserUsecase,
    required this.insertChatBckgndImgPathsUsecae,
    required this.deleteUserUsecase,
  }) : super(UserInitial()) {
    on<GetUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await getUserUsecase();
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserError(message: e.toString()));
      }
    });

    on<InsertUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final result = await insertUserUsecase(event.user);
        if (result) {
          emit(UserInserted());
        } else {
          emit(UserError(message: 'Insert Failed'));
        }
      } catch (e) {
        emit(UserError(message: e.toString()));
      }
    });

    on<DeleteUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final result = await deleteUserUsecase(event.userId);
        if (result) {
          add(GetUserEvent());
          emit(UserDeleted());
        } else {
          emit(UserError(message: 'Delete Failed'));
        }
      } catch (e) {
        emit(UserError(message: e.toString()));
      }
    });

    on<InsertChatBackgroundImagesPathsEventInUserBloc>((event, emit) async {
      for (var element in event.imgPaths) {
        await insertChatBckgndImgPathsUsecae(
          ChatBckgndImgPathsEntity(
            imgPaths: element,
            isActive: false,
            id: DateTime.now().microsecondsSinceEpoch,
          ),
        );
      }
    });
  }
}
