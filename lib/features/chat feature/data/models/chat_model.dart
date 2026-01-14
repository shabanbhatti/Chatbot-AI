import 'package:chatbot_ai/features/chat%20feature/domain/entity/chat_entity.dart';
import 'package:equatable/equatable.dart';

class ChatRoomModel extends Equatable {
  final int id;
  final String createdAt;
  final String title;
  final bool isTitleAssigned;
  final bool isPin;
  const ChatRoomModel({
    required this.id,
    required this.isTitleAssigned,
    required this.createdAt,
    required this.title,
    required this.isPin,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      id: map[col_id] ?? 0,
      createdAt: map[col_createdAt] ?? '',
      isPin: map[col_isPin] == 0 ? false : true,
      title: map[col_title] ?? '',
      isTitleAssigned: map[col_isTitleAssigned] == 0 ? false : true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      col_id: id,
      col_createdAt: createdAt,
      col_title: title,
      col_isTitleAssigned: isTitleAssigned ? 1 : 0,
      col_isPin: isPin ? 1 : 0,
    };
  }

  ChatRoomEntity toEntity() {
    return ChatRoomEntity(
      id: id,
      createdAt: createdAt,
      title: title,
      isTitleAssigned: isTitleAssigned,
      isPin: isPin,
    );
  }

  static const String tableName = 'all_chat';
  static const String col_title = 'title';
  static const String col_id = 'id';
  static const String col_isTitleAssigned = 'is_title_assigned';
  static const String col_isPin = 'is_pin';
  static const String col_createdAt = 'created_at';

  static const String createTable =
      '''
  CREATE TABLE $tableName(
    $col_id INTEGER PRIMARY KEY,
    $col_createdAt TEXT,
    $col_title TEXT,
    $col_isTitleAssigned INTEGER,
    $col_isPin INTEGER
  )
  ''';

  @override
  List<Object?> get props => [id, createdAt, isTitleAssigned, isPin];
}

class ChatModel extends Equatable {
  final int? id;
  final int chatRoomId;
  final String message;
  final String createdAt;
  final String? imgPath;
  final String role;
  final bool isFav;

  const ChatModel({
    required this.chatRoomId,
    required this.isFav,
    required this.message,
    required this.createdAt,
    required this.role,
    this.imgPath,
    required this.id,
  });

  // factory ChatModel.fromJson(Map<String, dynamic> json, int chatRoomId) {
  //   return ChatModel(
  //     chatRoomId: chatRoomId,
  //     message: json['message'] ?? '',
  //     createdAt: json['created_at'] ?? '',
  //     imgPath: json['img'] ?? '',
  //     role: json['role'] ?? '',
  //     isFav: json['isFavourite'] ?? false,
  //     id: json['']??''
  //   );
  // }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map[col_id],
      chatRoomId: map[col_allChatId],
      message: map[col_message] ?? '',
      createdAt: map[col_createdAt] ?? '',
      imgPath: map[col_imgPath] ?? '',
      role: map[col_role] ?? '',
      isFav: map[col_Fav] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      col_allChatId: chatRoomId,
      col_message: message,
      col_createdAt: createdAt,
      col_imgPath: imgPath ?? '',
      col_role: role,
      col_Fav: isFav ? 1 : 0,
      col_id: id,
    };
  }

  ChatEntity toEntity() {
    return ChatEntity(
      chatRoomId: chatRoomId,
      id: id ?? 0,
      message: message,
      createdAt: createdAt,
      role: role,
      isFav: isFav,
      imgPath: imgPath ?? '',
    );
  }

  static const String tableName = 'chat_table';

  static const String col_id = 'col_id';
  static const String col_allChatId = 'col_allChatId';
  static const String col_message = 'col_message';
  static const String col_createdAt = 'col_createdAt';
  static const String col_imgPath = 'col_imgPath';
  static const String col_role = 'col_role';
  static const String col_Fav = 'col_Fav';

  static const String createTable =
      '''
  CREATE TABLE $tableName(
    $col_id INTEGER,
    $col_allChatId INTEGER,
    $col_message TEXT,
    $col_imgPath TEXT,
    $col_createdAt TEXT,
    $col_role TEXT,
    $col_Fav INTEGER,
    FOREIGN KEY($col_allChatId) REFERENCES ${ChatRoomModel.tableName}(id) ON DELETE CASCADE
  )
  ''';

  @override
  List<Object?> get props => [
    id,
    chatRoomId,
    message,
    createdAt,
    imgPath,
    role,
    isFav,
  ];
}
