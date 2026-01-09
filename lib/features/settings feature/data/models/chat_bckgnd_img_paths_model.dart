import 'package:chatbot_ai/core/shared%20domain/entity/chat_bckgnd_img_path_entity.dart';
import 'package:equatable/equatable.dart';

class ChatBckgndImgPathsModel extends Equatable {
  final String imgPaths;
  final int? id;
  final bool isActive;
  const ChatBckgndImgPathsModel({
    required this.imgPaths,
    required this.isActive,
    required this.id,
  });

  factory ChatBckgndImgPathsModel.fromMap(Map<String, dynamic> map) {
    return ChatBckgndImgPathsModel(
      imgPaths: map[imgPathCol] ?? '',
      isActive: map[isActiveCol] == 1 ? true : false,
      id: map[idCol] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {imgPathCol: imgPaths, idCol: id, isActiveCol: isActive ? 1 : 0};
  }

  static const String tableName = 'chat_background_table';
  static const String imgPathCol = 'img_path_col';
  static const String idCol = 'id_col';
  static const String isActiveCol = 'isActive_col';

  static const String createTable =
      '''CREATE TABLE $tableName($imgPathCol TEXT,$idCol INTEGER PRIMARY KEY,$isActiveCol INTEGER)''';

  ChatBckgndImgPathsEntity toEntity() {
    return ChatBckgndImgPathsEntity(
      imgPaths: imgPaths,
      isActive: isActive,
      id: id,
    );
  }

  @override
  List<Object?> get props => [imgPaths, id, isActive];
}
