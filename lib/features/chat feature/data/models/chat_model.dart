import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:equatable/equatable.dart';

class ChatModel extends Equatable {
  final int? id;
  final String message;
  final String createdAt;
  final String? imgPath;
  final String role;

  const ChatModel({
    required this.message,
    required this.createdAt,
    required this.role,
    this.imgPath,
    this.id,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      message: json['message'] ?? '',
      createdAt: json['created_at'] ?? '',
      imgPath: json['imgPath'] ?? '',
      role: json['role'] ?? '',
    );
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      message: map[col_message] ?? '',
      createdAt: map[col_createdAt] ?? '',
      imgPath: map[col_imgPath] ?? '',
      role: map[col_role] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      col_message: message,
      col_createdAt: col_createdAt,
      col_imgPath: (imgPath == null || imgPath == '') ? '' : imgPath,
      col_role: role,
    };
  }

  ChatEntity toEntity() {
    return ChatEntity(
      message: message,
      createdAt: createdAt,
      role: role,
      imgPath: imgPath ?? '',
      id: id ?? 0,
    );
  }

  static String tableName = 'chat_table';
  static String col_message = 'col_message';
  static String col_createdAt = 'col_createdAt';
  static String col_imgPath = 'col_imgPath';
  static String col_role = 'col_role';
  static String col_id = 'col_id';

  static String createTable =
      '''CREATE TABLE $tableName($col_id INTEGER PRIMARY KEY AUTOINCREMENT, $col_message TEXT, $col_imgPath TEXT, $col_createdAt TEXT, $col_role TEXT)''';

  @override
  List<Object?> get props => [message, createdAt, imgPath, role, id];
}
