import 'package:equatable/equatable.dart';

class ChatBckgndImgPathsEntity extends Equatable {
  final String imgPaths;
  final int? id;
  final bool isActive;
  const ChatBckgndImgPathsEntity({
    required this.imgPaths,
    required this.isActive,
    this.id,
  });

  ChatBckgndImgPathsEntity copyWith({
    String? imgPaths,
    int? id,
    bool? isActive,
  }) {
    return ChatBckgndImgPathsEntity(
      imgPaths: imgPaths ?? this.imgPaths,
      isActive: isActive ?? this.isActive,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [imgPaths, id, isActive];
}
