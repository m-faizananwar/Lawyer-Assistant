import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addChatToFirebase(List<ChatMessage> messages, int chatNumber) async {
  User user = FirebaseAuth.instance.currentUser!;
  final userDoc = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection('chats').doc("chat : ${chatNumber}").get();

  Map<String, dynamic> chat = {};
  for (int i = 0; i < messages.length; i++) {
    chat['message$i'] = messages[i].text;
  }
  if (!userDoc.exists) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('chats').doc("chat : ${chatNumber}").set({
      'chat': chatNumber,
      'messages': chat
    });
  } else {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('chats').doc("chat : ${chatNumber}").update({
      'messages': chat
    });
  }
}
// final hi =

Future<List<ChatMessage>> getChatHistory(int chatNumber, String imagePath) async {
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(id: "1", firstName: "LexiPAK", profileImage: imagePath);
  User user = FirebaseAuth.instance.currentUser!;
  final userDoc = await FirebaseFirestore.instance.collection("users").doc(user.uid);
  final chatDoc = await userDoc.collection("chats").doc("chat : ${chatNumber}").get();

  List<ChatMessage> messages = [];

  Map<String, dynamic> chat = {};
  if (chatDoc.exists) {
    chat = chatDoc['messages'];
  }

  for (int i = 0; i < chat.length; i++) {
    ChatMessage lastMessage;
    if (i.isEven) {
      lastMessage = ChatMessage(text: chat['message$i'].toString(), user: geminiUser, createdAt: DateTime.now());
    } else {
      lastMessage = ChatMessage(text: chat['message$i'].toString(), user: currentUser, createdAt: DateTime.now());
    }
    messages = [
      ...messages,
      lastMessage,
    ];
  }

  return messages;
}
