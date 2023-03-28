import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_coach/chat_bloc/chat_bloc.dart';
import 'package:your_coach/constants.dart';
import 'package:your_coach/question_answer.dart';
import 'package:your_coach/screens/side_drawer.dart';
import 'package:your_coach/utility.dart';

// : remove avatar
// : increase the size of the text box
// TODO: change the size of the message bubble
// TODO: change the color of the message bubble

// TODO: change the format of deserialize and serialize of message object

// This hold all the messages that needs to be sent to the api
// List<ChatMessage> messages = [
//   const ChatMessage(text: "Hello", isMe: true),
//   const ChatMessage(text: "Hello", isMe: false),
// ];

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc()..add(ChatEventLoadChat()),
        ),
      ],
      child: Scaffold(
        drawer: SideDrawer(
            onDropdownChanged: (x) {},
            onSliderChanged: (y) {},
            onToggleChanged: (z) {}),
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 75,
          backgroundColor: Colors.black,
          title: const Text('Your Coach'),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  print("Builder is called");
                  if (state is ChatInitial) {
                    return const Center(
                      child: Text('Start chatting'),
                    );
                  } else if (state is ChatLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ChatLoaded) {
                    List<Message> messages = state.messages;
                    for (var i = 0; i < messages.length; i++) {
                      print(
                          "Printing inside list view: " + messages[i].content);
                    }

                    return ListView.builder(
                      itemBuilder: (_, int index) => ChatMessage(
                        text: messages[index].content,
                        isMe: messages[index].role == 'user',
                      ),
                      itemCount: messages.length,
                    );
                  } else {
                    return const Center(
                      child: Text('Error'),
                    );
                  }
                },
              ),
            ),
            const Divider(height: 3.0),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: ChatTextBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatTextBox extends StatelessWidget {
  ChatTextBox({super.key});
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              child: TextField(
                controller: _textController,
                // onSubmitted: _handleSubmit,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                String message = _textController.text.capitalize();
                context
                    .read<ChatBloc>()
                    .add(ChatEventSendMessage(message: message));
                _textController.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isMe;
  const ChatMessage({super.key, required this.text, required this.isMe});

  // constructor which takes the serialised data and returns the ChatMessage object
  ChatMessage.fromJson(Map<String, dynamic> json, {super.key})
      : text = json['text'],
        isMe = json['isMe'];

  // method which returns the serialised data of the message
  Map<String, dynamic> toJson() => {
        'text': text,
        'isMe': isMe,
      };

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle textStyle = themeData.textTheme.bodyLarge!.copyWith(
      color: isMe ? Colors.black : Colors.white,
    );

    return Container(
      padding: chatBubbleTextPadding,
      decoration: BoxDecoration(
        color: isMe ? Colors.grey[200] : Colors.black54,
      ),
      child: Text(
        text,
        style: textStyle,
        // textAlign: isMe ? TextAlign.right : TextAlign.left,
      ),
    );
  }
}


// Box decoration to make it look like chatapp
// BoxDecoration(
//         color: isMe ? Colors.grey[200] : Colors.black,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(isMe ? 12 : 0.0),
//           topRight: Radius.circular(isMe ? 0.0 : 12),
//           bottomLeft: const Radius.circular(12),
//           bottomRight: const Radius.circular(12),
//         ),
//       )