import 'dart:convert';
import 'dart:io';

import 'package:chatbot_ai/core/constants/chat_role_constants.dart';
import 'package:chatbot_ai/features/chat%20feature/data/models/chat_model.dart';
import 'package:dio/dio.dart';

abstract class ChatRemoteDatasource {
  Future<ChatModel> sendPrompt(ChatModel chatModel);
}

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final Dio dio;
  const ChatRemoteDatasourceImpl({required this.dio});

  @override
  Future<ChatModel> sendPrompt(ChatModel chatModel) async {
    String? img;
    if (chatModel.imgPath != null) {
      File file = File(chatModel.imgPath ?? '');
      final bytes = await file.readAsBytes();
      img = base64Encode(bytes);
    }

    var responce = await dio.post(
      '/v1beta/models/gemini-2.5-flash:generateContent',
      data: {
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": chatModel.message},
              if (img != null)
                {
                  "inlineData": {"mimeType": "image/jpeg", "data": img},
                },
            ],
          },
        ],
      },
    );

    Map<String, dynamic> data = responce.data;

    String reply = data['candidates'][0]['content']['parts'][0]['text'];

    return ChatModel(
      message: reply,
      createdAt: DateTime.now().toString(),
      role: ChatRoleConstants.model,
      imgPath: null,
    );
  }
}
