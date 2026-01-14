import 'package:equatable/equatable.dart';

class ChatRoomEntity extends Equatable {
  final int id;
  final String title;
  final String createdAt;
  final bool isTitleAssigned;
  final bool isPin;
  const ChatRoomEntity({
    required this.id,
    required this.title,
    required this.isTitleAssigned,
    required this.createdAt,
    required this.isPin,
  });

  ChatRoomEntity copyWith({
    int? id,
    String? title,
    String? createdAt,
    bool? isTitleAssigned,
    bool? isPin,
  }) {
    return ChatRoomEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      isTitleAssigned: isTitleAssigned ?? this.isTitleAssigned,
      isPin: isPin ?? this.isPin,
    );
  }

  @override
  List<Object?> get props => [id, createdAt, title, isTitleAssigned, isPin];
}

class ChatEntity extends Equatable {
  final int? id;
  final String message;
  final String createdAt;
  final int chatRoomId;
  final String? imgPath;
  final String role;
  final bool isFav;

  const ChatEntity({
    required this.message,
    required this.chatRoomId,
    required this.isFav,
    required this.id,
    required this.createdAt,
    required this.role,
    this.imgPath,
  });
  ChatEntity copyWith({
    int? id,
    String? message,
    String? createdAt,
    String? imgPath,
    String? role,
    bool? isFav,
    int? chatRoomId,
  }) {
    return ChatEntity(
      chatRoomId: chatRoomId ?? this.chatRoomId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
      id: id ?? this.id,
      imgPath: imgPath ?? this.imgPath,
      isFav: isFav ?? this.isFav,
    );
  }

  @override
  List<Object?> get props => [
    message,
    createdAt,
    imgPath,
    role,
    id,
    isFav,
    chatRoomId,
  ];
}
