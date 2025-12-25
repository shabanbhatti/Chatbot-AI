import 'package:chatbot_ai/features/chat%20feature/presentation/pages/chat%20page/widgets/bottom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.advancedDrawerController});
  final AdvancedDrawerController advancedDrawerController;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController chatController = TextEditingController();
  ValueNotifier<String> chatNotifier = ValueNotifier('');
  @override
  void dispose() {
    chatController.dispose();
    chatNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () {
            widget.advancedDrawerController.showDrawer();
          },
          child: Icon(CupertinoIcons.slider_horizontal_3, size: 25),
        ),
        middle: Text(
          'Ai Chatbot',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      child: Center(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: CustomScrollView(slivers: [
                    
                  ],
                )),
              BottomWidgets(
                chatNotifier: chatNotifier,
                chatController: chatController,
                onMic: () {},
                onSend: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
