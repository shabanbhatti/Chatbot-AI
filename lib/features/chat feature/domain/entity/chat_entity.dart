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
  final List<String> imgPaths;
  final String? imageGeneratedPath;
  final String role;
  final bool isFav;

  const ChatEntity({
    required this.message,
    required this.chatRoomId,
    required this.isFav,
    this.imageGeneratedPath,
    required this.id,
    required this.createdAt,
    required this.role,
    required this.imgPaths,
  });
  ChatEntity copyWith({
    int? id,
    String? message,
    String? createdAt,
    List<String>? imgPaths,
    String? role,
    bool? isFav,
    int? chatRoomId,
    String? imageGeneratedPath,
  }) {
    return ChatEntity(
      chatRoomId: chatRoomId ?? this.chatRoomId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
      id: id ?? this.id,
      imgPaths: imgPaths ?? this.imgPaths,
      isFav: isFav ?? this.isFav,
      imageGeneratedPath: imageGeneratedPath ?? this.imageGeneratedPath,
    );
  }

  @override
  List<Object?> get props => [
    message,
    createdAt,
    imgPaths,
    role,
    id,
    isFav,
    chatRoomId,
    imageGeneratedPath,
  ];
}

class ImagePathsEntity extends Equatable {
  final String imgPath;
  final int id;
  final int wholeImgId;
  const ImagePathsEntity({
    required this.id,
    required this.imgPath,
    required this.wholeImgId,
  });

  @override
  List<Object?> get props => [imgPath, id, wholeImgId];
}
