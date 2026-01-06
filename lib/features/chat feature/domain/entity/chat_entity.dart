import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final int? id;
  final String message;
  final String createdAt;

  final String? imgPath;
  final String role;
  final bool isFav;

  const ChatEntity({
    required this.message,

    required this.isFav,
    this.id,
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
  }) {
    return ChatEntity(
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
      id: id ?? this.id,
      imgPath: imgPath ?? this.imgPath,
      isFav: isFav ?? this.isFav,
    );
  }

  @override
  List<Object?> get props => [message, createdAt, imgPath, role, id, isFav];
}
