import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final int? id;
  final String message;
  final String createdAt;
  final String? imgPath;
  final String role;

  const ChatEntity({
    required this.message,
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
  }) {
    return ChatEntity(
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
      id: id ?? this.id,
      imgPath: imgPath ?? this.imgPath,
    );
  }

  @override
  List<Object?> get props => [message, createdAt, imgPath, role, id];
}
