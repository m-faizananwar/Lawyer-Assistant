import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:national_lawyer_assistant/Login/Google%20Login/google_login.dart';
import 'package:national_lawyer_assistant/Login/Screens/login_screen.dart';
import 'package:national_lawyer_assistant/Login/Services/authentication.dart';
import 'package:national_lawyer_assistant/Login/Widget/button.dart';
import 'package:national_lawyer_assistant/Login/Widget/snack_bar.dart';
import 'package:national_lawyer_assistant/chathistory.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'Screens/Login/ui/login.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser laxiPakUser = ChatUser(
      id: "1", firstName: "LaxiPAK", profileImage: "assets/images/box.png");
  bool messagePending = false;
  List<ChatUser> users = [];
  List<ChatMessage> messages = [];
  User user = FirebaseAuth.instance.currentUser!;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? chatCount;
  bool scrollBottomOptionDisabled = false;
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var chatCollectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('chats');

      QuerySnapshot chatSnapshot = await chatCollectionRef.get();
      chatCount = chatSnapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String logoAsset = isDarkMode
        ? "assets/images/ChatAppLogo.png"
        : "assets/images/ChatAppLogoDark.png";
    laxiPakUser.profileImage = logoAsset;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        shadowColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.home,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Welcome! How can we assist you today?",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ListTile(
                      onTap: () async {
                        var chatCollectionRef = FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('chats');
                        QuerySnapshot chatSnapshot =
                            await chatCollectionRef.get();
                        int newChatCount = chatSnapshot.docs.length;

                        setState(() {
                          chatCount = newChatCount;
                          messages = [];
                          _scaffoldKey.currentState?.closeDrawer();
                        });
                      },
                      leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                logoAsset,
                                fit: BoxFit.cover,
                              ))),
                      title: Text(
                        "Start New Chat",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.dashboard_customize_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text(
                        "About LaxiPAK",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4),
                      child: Divider(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('chats')
                            .snapshots(),
                        builder: (context, snapshots) {
                          if (snapshots.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshots.hasError) {
                            return Center(
                                child: Text("Error: ${snapshots.error}"));
                          }
                          if (!snapshots.hasData ||
                              snapshots.data!.docs.isEmpty) {
                            return Center(child: Text("No chats available"));
                          }
                          final chatDocs = snapshots.data!.docs;
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: chatDocs.length,
                            itemBuilder: (context, index) {
                              final message = chatDocs[index]['messages']
                                      ['message0']
                                  .toString();
                              final maxLength = 27;
                              final safeLength = message.length < maxLength
                                  ? message.length
                                  : maxLength;

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      const Color.fromARGB(255, 169, 203, 230),
                                  child: Text(
                                    "${index + 1}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  "${message.substring(0, safeLength)}...",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                onTap: () async {
                                  List<ChatMessage> msgs =
                                      await getChatHistory(index, logoAsset);
                                  setState(() {
                                    scrollBottomOptionDisabled = true;
                                    chatCount = index;
                                    messages = msgs;
                                    _scaffoldKey.currentState?.closeDrawer();
                                  });
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: (user.photoURL != null)
                        ? Image.network(
                            "${user.photoURL}",
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Theme.of(context).colorScheme.onSecondary,
                            child: Text("L"),
                          ),
                  ),
                ),
                title: Text(
                  "${(user.displayName == '') ? "User" : user.displayName}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                trailing: Icon(Icons.more_horiz),
              ),
              AppButton(
                onTab: () async {
                  await FirebaseServices().googleSignOut();
                  await AuthServices().logOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                text: "Log out",
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.drag_handle,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "LexiPAK",
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () async {
                    var chatCollectionRef = FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('chats');
                    QuerySnapshot chatSnapshot = await chatCollectionRef.get();
                    int newChatCount = chatSnapshot.docs.length;

                    setState(() {
                      chatCount = newChatCount;
                      messages = [];
                    });
                  },
                ),
                PopupMenuButton<String>(
                  color: Theme.of(context).colorScheme.onPrimary,
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onSelected: (String result) async {
                    if (result == 'logout') {
                      await FirebaseServices().googleSignOut();
                      await AuthServices().logOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Log Out'),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(child: _buildUI(isDarkMode)),
    );
  }

  Widget _buildUI(bool isDarkMode) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (!messages.isEmpty)
                  ? Container()
                  : AvatarGlow(
                      startDelay: const Duration(milliseconds: 300),
                      glowColor: Theme.of(context).colorScheme.secondary,
                      glowShape: BoxShape.circle,
                      animate: true,
                      curve: Curves.fastOutSlowIn,
                      duration: const Duration(milliseconds: 2000),
                      repeat: true,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            isDarkMode
                                ? "assets/images/ChatAppLogo.png"
                                : "assets/images/ChatAppLogoDark.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ), // Background animation/icon
              // Add more widgets if needed
            ],
          ),
        ),
        DashChat(
          scrollToBottomOptions: ScrollToBottomOptions(
            disabled: scrollBottomOptionDisabled,
          ),
          typingUsers: users,
          currentUser: currentUser,
          onSend: _sendMessage,
          messages: messages,
          messageOptions: MessageOptions(
            showTime: false,
            currentUserContainerColor:
                isDarkMode ? Colors.purple[200] : Colors.purple[50],
            currentUserTextColor: Theme.of(context).colorScheme.secondary,
            containerColor: Colors.transparent,
            textColor: Theme.of(context).colorScheme.secondary,
          ),
          inputOptions: InputOptions(
            textController: textEditingController,
            sendButtonBuilder: (Function()? send) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: AvatarGlow(
                  startDelay: const Duration(milliseconds: 300),
                  glowColor: Colors.cyan,
                  glowShape: BoxShape.circle,
                  animate: messagePending,
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 91, 198, 98),
                      child: (messagePending || _isListening)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.primary),
                            )
                          : IconButton(
                              icon: Icon(Icons.send,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary), // Change the color to your desired color
                              onPressed: send,
                            ),
                    ),
                  ),
                ),
              );
            },
            leading: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: (!_isListening)
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            size: 30,
                            Icons.message,
                            color: Colors.cyan,
                          ),
                        ),
                      )
                    : Container(),
              )
            ],
            alwaysShowSend: true,
            sendOnEnter: true,
            inputDisabled: messagePending,
            inputTextStyle:
                TextStyle(color: Theme.of(context).colorScheme.secondary),
            inputDecoration: InputDecoration(
                hintText:
                    (_isListening) ? "Speak now ..." : "Write a message...",
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 18,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: (messagePending)
                      ? Container()
                      : AvatarGlow(
                          startDelay: const Duration(milliseconds: 300),
                          glowColor: Colors.cyanAccent,
                          glowShape: BoxShape.circle,
                          animate: _isListening,
                          curve: Curves.fastOutSlowIn,
                          duration: const Duration(milliseconds: 2000),
                          repeat: true,
                          child: IconButton(
                            color: Colors.cyanAccent,
                            icon: Icon(
                              _isListening ? Icons.pause : Icons.mic,
                              color: Colors.white,
                            ),
                            onPressed: _listen,
                          ),
                        ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.primary,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.cyanAccent),
                  borderRadius: BorderRadius.circular(30),
                )),
            cursorStyle:
                CursorStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      ],
    );
  }

  void _sendMessage(ChatMessage chatMessage) async {
    ChatMessage message = ChatMessage(
        user: laxiPakUser,
        createdAt: DateTime.now(),
        text: "An error Occured.");
    ;
    setState(() {
      messagePending = true;
      users = [laxiPakUser];
      messages = [chatMessage, ...messages];
      scrollBottomOptionDisabled = false;
    });
    try {
      final query = chatMessage.text;
      final url = Uri.https(
          'chatai.seecs.edu.pk:8000', '/api/v1/predict/', {'query': query});

      // Print the full URL
      // print('Requesting URL: $url');

      final res = await http.get(url);
      // print('Response body: ${res.body}');

      // If you want to decode and print the specific response
      final response = jsonDecode(res.body);
      message = ChatMessage(
          user: laxiPakUser,
          createdAt: DateTime.now(),
          text: response["response"].toString());
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      print(messagePending);
      setState(() {
        messagePending = false;
        users = [];
        messages = [message, ...messages];
      });
      await addChatToFirebase(messages, chatCount!);
      print(messagePending);
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech!.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech!.listen(
          onResult: (val) => setState(() {
            textEditingController.text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech!.stop();
    }
  }
}
