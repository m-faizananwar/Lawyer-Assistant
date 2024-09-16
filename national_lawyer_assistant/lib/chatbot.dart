import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:national_lawyer_assistant/utils/Services/google_login.dart';
import 'package:national_lawyer_assistant/utils/Services/authentication.dart';
import 'package:national_lawyer_assistant/utils/Widget/button.dart';
import 'package:national_lawyer_assistant/utils/chathistory.dart';
import 'package:national_lawyer_assistant/utils/const.dart';
import 'package:national_lawyer_assistant/utils/const.dart';
import 'package:shimmer/shimmer.dart';
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
  ChatUser currentUser = ChatUser(
      id: "0", firstName: "User", profileImage: "assets/images/user.png");
  ChatUser botUser = ChatUser(
      id: "1",
      firstName: "Law App",
      profileImage: "assets/images/ErrorImage.png");
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
    final String logoAsset = 'assets/images/ChatBotLogo.png';
    String userLogo = 'assets/images/user.png';
    botUser.profileImage = logoAsset;
    if (user.photoURL != null) {
      userLogo = user.photoURL.toString();
      currentUser.profileImage = userLogo;
    }
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        shadowColor: surface,
        backgroundColor: primary,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.back_hand,
                          color: Colors.yellow,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Shimmer.fromColors(
                            baseColor: purple500,
                            highlightColor: purple200,
                            child: Text(
                              "Welcome, I\'m your personal Assistant! Nice to meet you. ",
                              style: TextStyle(
                                fontFamily: 'Suse',
                                color: primary,
                                fontSize: 18,
                              ),
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
                        setState(() {
                          _scaffoldKey.currentState?.closeDrawer();
                        });
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => ChatScreen()));
                      },
                      leading: CircleAvatar(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                logoAsset,
                                fit: BoxFit.cover,
                              ))),
                      title: Text(
                        "Start New Chat",
                        style: TextStyle(
                            color: onSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.dashboard_customize_outlined,
                        color: onSecondary,
                      ),
                      title: Text(
                        "About Us",
                        style: TextStyle(
                            color: onSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4),
                      child: Divider(
                        color: onSecondary,
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
                                  backgroundColor: onPrimary,
                                  child: Shimmer.fromColors(
                                    baseColor: surface,
                                    highlightColor: purple200,
                                    child: Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                          color: primary,
                                          fontFamily: 'Suse',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                title: Shimmer.fromColors(
                                  baseColor: surface,
                                  highlightColor: Colors.deepPurple[300]!,
                                  child: Text(
                                    "${message.substring(0, safeLength)}...",
                                    style: TextStyle(
                                        fontFamily: 'Suse',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w200),
                                  ),
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
              Container(
                decoration: BoxDecoration(
                    color: onSecondary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(120),
                    )),
                child: ListTile(
                  leading: CircleAvatar(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: (user.photoURL != null)
                            ? Image.network(
                                "${userLogo}",
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                userLogo,
                                fit: BoxFit.cover,
                              )),
                  ),
                  title: Text(
                    "${(user.displayName == '') ? "User" : user.displayName}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  trailing: Icon(Icons.more_horiz),
                ),
              ),
              Container(
                color: onSecondary,
                child: AppButton(
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
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: primary,
        leading: Shimmer.fromColors(
          baseColor: onSecondary,
          highlightColor: purple500,
          child: IconButton(
            icon: Icon(
              Icons.drag_handle,
              color: onSecondary,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(
              baseColor: onSecondary,
              highlightColor: purple500,
              child: Text(
                "Law App",
                style: TextStyle(
                    fontFamily: 'Suse', fontSize: 16, color: onSecondary),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Shimmer.fromColors(
                  baseColor: onSecondary,
                  highlightColor: purple500,
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                    ),
                    onPressed: () async {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ChatScreen()));
                    },
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: onSecondary,
                  highlightColor: purple500,
                  child: PopupMenuButton<String>(
                    color: onSecondary,
                    icon: Icon(
                      Icons.more_vert,
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
                ),
              ],
            )
          ],
        ),
      ),
      backgroundColor: surface,
      body: SafeArea(child: _buildUI()),
    );
  }

  Widget _buildUI() {
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
                      glowColor: purple500,
                      glowShape: BoxShape.circle,
                      animate: true,
                      curve: Curves.fastOutSlowIn,
                      duration: const Duration(milliseconds: 2000),
                      repeat: true,
                      child: CircleAvatar(
                        radius: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'assets/images/ChatBotLogo.png',
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
            showOtherUsersName: false,
            maxWidth: MediaQuery.of(context).size.width / 1.5,
            showCurrentUserAvatar: true,
            messagePadding: EdgeInsets.all(16),
            showTime:
                false, // Set to true to display the time as shown in the image
            currentUserContainerColor:
                onSecondary, // Dark purple background color
            currentUserTextColor: primary, // White text color for current user
            containerColor:
                Color(0xFF6A0DAD), // Slightly lighter purple for other users
            textColor: Colors.white, // White text color for other users
            borderRadius: 18.0, // Slightly rounded corners for the message box
            timeTextColor: Colors.black, // Light grey color for the time text
            timeFontSize: 10.0, // Small font size for time display
            timePadding: EdgeInsets.only(top: 5), // Padding above the time text
          ),
          inputOptions: InputOptions(
            textController: textEditingController,
            sendButtonBuilder: (Function()? send) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: AvatarGlow(
                  startDelay: const Duration(milliseconds: 300),
                  glowColor: primary,
                  glowShape: BoxShape.circle,
                  animate: messagePending,
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      backgroundColor: surface,
                      child: (messagePending || _isListening)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                backgroundColor: onSecondary,
                                color: purple500,
                                strokeWidth: 5,
                              ),
                            )
                          : IconButton(
                              icon: Icon(Icons.send_outlined,
                                  color: primary.withOpacity(
                                      0.6)), // Change the color to your desired color
                              onPressed: send,
                            ),
                    ),
                  ),
                ),
              );
            },
            alwaysShowSend: true,
            sendOnEnter: true,
            inputDisabled: messagePending,
            inputTextStyle: TextStyle(
                color: onSecondary,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.2,
                fontSize: 18),
            inputDecoration: InputDecoration(
                hintText: (_isListening == true)
                    ? "Speak now ..."
                    : "Write a message ...",
                hintStyle: TextStyle(
                  fontFamily: 'Suse',
                  color: onSecondary,
                  fontSize: 18,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: (messagePending == true)
                      ? Container()
                      : AvatarGlow(
                          startDelay: const Duration(milliseconds: 300),
                          glowColor: surface,
                          glowShape: BoxShape.circle,
                          animate: _isListening,
                          curve: Curves.fastOutSlowIn,
                          duration: const Duration(milliseconds: 2000),
                          repeat: true,
                          child: IconButton(
                            color: Colors.transparent,
                            icon: Icon(
                              _isListening ? Icons.pause : Icons.mic,
                              color: Colors.white70,
                            ),
                            onPressed: _listen,
                          ),
                        ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(14),
                ),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.5),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(14),
                )),
            cursorStyle: CursorStyle(color: onSecondary),
          ),
        ),
      ],
    );
  }

  void _sendMessage(ChatMessage chatMessage) async {
    ChatMessage message = ChatMessage(
        user: botUser, createdAt: DateTime.now(), text: "An error Occured.");
    ;
    setState(() {
      messagePending = true;
      users = [botUser];
      messages = [chatMessage, ...messages];
      scrollBottomOptionDisabled = false;
    });
    try {
      final query = chatMessage.text;
      final url =
          Uri.https('lawyer.logixos.com', '/api/v1/predict/', {'query': query});

      // Print the full URL
      // print('Requesting URL: $url');

      final res = await http.get(url);
      final response = jsonDecode(res.body);
      message = ChatMessage(
          user: botUser,
          createdAt: DateTime.now(),
          text: response["response"].toString() +
              "\n\n" +
              response["sources"].toString());
    } catch (e) {
      print(e.toString());
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
            textEditingController.text += ' ' + val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech!.stop();
    }
  }
}
