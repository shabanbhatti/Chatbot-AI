import 'dart:convert';
import 'dart:io';

import 'package:chatbot_ai/core/constants/chat_role_constants.dart';
import 'package:chatbot_ai/features/chat%20feature/data/models/chat_model.dart';
import 'package:dio/dio.dart';

abstract class ChatRemoteDatasource {
  Future<ChatModel> sendPrompt(ChatModel chatModel);
  Future<String> voiceToText(File filePath);
}

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final Dio dio;
  const ChatRemoteDatasourceImpl({required this.dio});

  @override
  Future<ChatModel> sendPrompt(ChatModel chatModel) async {
    List<String> imgList = [];
    if (chatModel.imgPaths.isNotEmpty) {
      for (var element in chatModel.imgPaths) {
        File file = File(element);
        final bytes = await file.readAsBytes();
        imgList.add(base64Encode(bytes));
      }
    }

    var responce = await dio.post(
      '/v1beta/models/gemini-2.5-flash:generateContent',
      data: {
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": chatModel.message},
              if (imgList.isNotEmpty)
                ...imgList.map(
                  (e) => {
                    "inlineData": {"mimeType": "image/jpeg", "data": e},
                  },
                ),
            ],
          },
        ],
      },
    );

    Map<String, dynamic> data = responce.data;

    String reply = data['candidates'][0]['content']['parts'][0]['text'];

    return ChatModel(
      chatRoomId: chatModel.chatRoomId,
      message: reply,
      createdAt: DateTime.now().toString(),
      role: ChatRoleConstants.model,
      isFav: false,
      imgPaths: [],
      id: DateTime.now().microsecondsSinceEpoch,
    );
  }

  @override
  Future<String> voiceToText(File filePath) async {
    var file = await filePath.readAsBytes();
    var base64Audio = base64Encode(file);
    var responce = await dio.post(
      '/v1beta/models/gemini-2.5-flash:generateContent',
      data: {
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": "Please transcribe this audio file to text accurately."},
              {
                "inlineData": {"mimeType": "audio/wav", "data": base64Audio},
              },
            ],
          },
        ],
      },
      options: Options(headers: {"Content-Type": "application/json"}),
    );

    return responce.data['candidates'][0]['content']['parts'][0]['text'];
  }
}
