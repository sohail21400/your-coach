
//   _sendMessage() async {
//     final question = textEditingController.text;
//     setState(() {
//       textEditingController.clear();
//       loading = true;
//       questionAnswers.add(
//         QuestionAnswer(
//           question: question,
//           answer: StringBuffer(),
//         ),
//       );
//     });
//     final testRequest = CompletionRequest(
//       stream: true,
//       maxTokens: 4000,
//       messages: [Message(role: Role.user.name, content: question)],
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
// }
