import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'chat_event.dart';
part 'chat_state.dart';

// TODO: fix the black screen delay when send button is pressed

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  // this will hold all the message object whcih will be displayed on the screen
  List<Message> messages = [];

  static final apiKey = dotenv.get('OPEN_AI_API_KEY');
  final chatGpt = ChatGpt(apiKey: apiKey);

  bool continiousConversation = true;

  void addUserMessageToMessagesList(String prompt) {
    // create a new list with all the old messages in it and add the new messge in the new list
    // this if for forcing the list view to rebuild
    // here new list is assigned to the same old variable
    messages = [...messages];
    if (prompt.isNotEmpty) {
      messages.add(Message(role: Role.user.name, content: prompt));
    }
  }

  // add assistant message to the messages list
  void addAssistantMessageToMessageList(String? newWordFromStream) {
    // create a new list with all the old messages in it and add the new messge in the new list
    // this if for forcing the list view to rebuild
    // here new list is assigned to the same old variable
    messages = [...messages];
    if (newWordFromStream != null) {
      // if the last message is already from the assistant, then append the new message to the last message's content
      if (messages.last.role == Role.assistant.name) {
        final oldMessage = messages.removeLast();
        messages.add(Message(
            role: Role.assistant.name,
            content: oldMessage.content + newWordFromStream));
      } // else if the last message is from the user, then add a new message ie. from the assistant to the list
      else {
        messages.add(
            Message(role: Role.assistant.name, content: newWordFromStream));
      }
    }
  }

  // this function returns the stream of response from the api
  Future<Stream<StreamCompletionResponse>?> sendMessage() async {
    List<Message> prompt = [];
    if (continiousConversation) {
      // for continious conversation, we need to pass the previous messages as well to the api as prompt
      // prompt = json.encode(requestMessages);
      prompt = messages;
    } else {
      final lastMessage = messages.last;
      if (lastMessage.role == Role.user.name) {
        // prompt = json.encode(lastMessage);
        prompt = [lastMessage];
      }
    }
    final gptRequest = CompletionRequest(
      stream: true,
      maxTokens: 4000,
      messages: prompt,
    );

    try {
      final stream = await chatGpt.createChatCompletionStream(gptRequest);
      return stream;
    } catch (error) {
      // TODO: Handle error
      print(error);
      return null;
    }
  }

  ChatBloc() : super(ChatInitial()) {
    on<ChatEventLoadChat>((event, emit) async {});

    on<ChatEventSendMessage>((event, emit) async {
      // take the prompt from the event
      final prompt = event.message;

      // show loading animation
      emit(ChatLoading());

      addUserMessageToMessagesList(prompt);
      emit(ChatLoaded(messages: messages));

      final stream = await sendMessage();

      if (stream != null) {
        await emit.forEach(stream, onData: (streamCompletionResponse) {
          final newWordFromStream =
              streamCompletionResponse.choices?.first.delta?.content;

          addAssistantMessageToMessageList(newWordFromStream);
          return ChatLoaded(messages: messages);
        }).catchError((error) {
          print("onError $error");
        }).whenComplete(() {
          print("Stream completed");
        });
      }
    });
  }
}

Stream<int> getFakeStream() async* {
  await Future.delayed(const Duration(seconds: 2));
  yield 1;
  await Future.delayed(const Duration(seconds: 2));
  yield 2;
  await Future.delayed(const Duration(seconds: 2));
  yield 3;
  await Future.delayed(const Duration(seconds: 2));
  yield 4;
}



// _sendMessage(String prompt) async {
//     setState(() {
//       _textController.clear();
//       loading = true;
//       questionAnswers.add(
//         QuestionAnswer(
//           question: prompt,
//           answer: StringBuffer(),
//         ),
//       );
//     });
//     final testRequest = CompletionRequest(
//       stream: true,
//       maxTokens: 4000,
//       messages: [Message(role: Role.user.name, content: prompt)],
//     );
//     await _streamResponse(testRequest);
//     setState(() => loading = false);
//   }

//   _streamResponse(CompletionRequest request) async {
//     streamSubscription?.cancel();
//     try {
//       final stream = await chatGpt.createChatCompletionStream(request);
//       streamSubscription = stream?.listen(
//         (event) => setState(
//           () {
//             if (event.streamMessageEnd) {
//               streamSubscription?.cancel();
//             } else {
//               return questionAnswers.last.answer.write(
//                 event.choices?.first.delta?.content,
//               );
//             }
//           },
//         ),
//       );
//     } catch (error) {
//       setState(() {
//         loading = false;
//         questionAnswers.last.answer.write("Error");
//       });
//       log("Error occurred: $error");
//     }
//   }