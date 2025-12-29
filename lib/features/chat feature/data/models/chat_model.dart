import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:equatable/equatable.dart';

class ChatModel extends Equatable {
  final int? id;
  final String message;
  final String createdAt;
  final String? imgPath;
  final String role;
  final bool isFav;

  const ChatModel({
    required this.isFav,
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
      isFav: false,
    );
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    print('--------------${map[col_Fav]}');
    return ChatModel(
      message: map[col_message] ?? '',
      createdAt: map[col_createdAt] ?? '',
      imgPath: map[col_imgPath] ?? '',
      role: map[col_role] ?? '',
      isFav: map[col_Fav] == 1 ? true : false,
      id: map[col_id] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      col_message: message,
      col_createdAt: createdAt,
      col_imgPath: (imgPath == null || imgPath == '') ? '' : imgPath,
      col_role: role,
      col_Fav: isFav == false ? 0 : 1,
    };
  }

  ChatEntity toEntity() {
    return ChatEntity(
      message: message,
      createdAt: createdAt,
      role: role,
      isFav: isFav,

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
  static String col_Fav = 'col_Fav';

  static String createTable =
      '''CREATE TABLE $tableName($col_id INTEGER PRIMARY KEY AUTOINCREMENT, $col_message TEXT, $col_imgPath TEXT, $col_createdAt TEXT, $col_role TEXT, $col_Fav INTEGER)''';

  @override
  List<Object?> get props => [message, createdAt, imgPath, role, id, isFav];
}
