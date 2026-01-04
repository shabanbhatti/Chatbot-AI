import 'package:chatbot_ai/core/domain/usecases/delete_user_usecase.dart';
import 'package:chatbot_ai/core/domain/usecases/get_user_usecase.dart';
import 'package:chatbot_ai/core/domain/usecases/insert_user_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserUsecase getUserUsecase;
  final InsertUserUsecase insertUserUsecase;
  final DeleteUserUsecase deleteUserUsecase;

  UserBloc({
    required this.getUserUsecase,
    required this.insertUserUsecase,
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
  }
}
