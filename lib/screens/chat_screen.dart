import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const id = 'chat_screen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final textFieldController = TextEditingController();
  String? messages;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      _auth.currentUser!;
    } catch (e) {
      throw Exception('something went wrong');
    }
  }
  //this is the code you will use if you want to retrieve data from the firebase database
  //if you want to get document from the database you can use the .getDocument function to get the document of a collection
  // void getMessageStream() async {
  //   await for (var snapshot in _firestore.collection('Messages').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: kGradientContainerStyle,
          ),
        ),
        actions: [
          PopupMenuButton(
            elevation: 5.0,
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text('Logout'),
              ),
            ],
            onSelected: (value) => {
              if (value == 1)
                {
                  _auth.signOut(),
                  Navigator.pop(context),
                }
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.only(right: 20.0),
          //   child: DropdownButton(
          //       icon: const Icon(
          //         Icons.more_vert,
          //         color: Colors.white,
          //         size: 25.0,
          //       ),
          //       items: const [
          //         DropdownMenuItem(
          //           value: 'Logout',
          //           child: Text(
          //             'Logout',
          //             style: TextStyle(fontSize: 10.0, fontFamily: 'Quicksand'),
          //           ),
          //         ),
          //       ],
          //       onChanged: (value) {
          //         if (value == 'Logout') {
          //           _auth.signOut();
          //           Navigator.pop(context);
          //         }
          //       }),
          // )
          // IconButton(
          //     icon: const Icon(Icons.more_vert),
          //     onPressed: () {
          //       _auth.signOut();
          //       Navigator.pop(context);
          //     }),
        ],
        title: const Text(
          'Intel5ive Chat Room',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/chatbg2.jpg'),
          fit: BoxFit.cover,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder(
              stream: _firestore
                  .collection('Messages')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text('no text yet'));
                }
                final messages = snapshot.data?.docs;
                List<MessageBubble> messagesWidgets = [];
                for (var message in messages!) {
                  final messageText = message.data()['text'];
                  String messageSender = message.data()['sender'];
                  final username = messageSender.split('@')[0];
                  final currentUser = _auth.currentUser?.email;
                  final messageWidget = MessageBubble(
                    username,
                    messageText,
                    currentUser == messageSender,
                  );
                  messagesWidgets.add(messageWidget);
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    children: messagesWidgets,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: textFieldController,
                      onChanged: (value) {
                        messages = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textFieldController.clear();
                      _firestore.collection('Messages').add({
                        'text': messages,
                        'sender': _auth.currentUser?.email,
                        'time': FieldValue.serverTimestamp(),
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(this.sender, this.text, this.isCurrentUser, {super.key});

  final String? sender;
  final String? text;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          isCurrentUser
              ? const SizedBox()
              : Text(
                  '$sender',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Color(0xff514a9d),
                  ),
                ),
          Container(
            decoration: BoxDecoration(
                gradient: isCurrentUser
                    ? kGradientContainerStyle
                    : const LinearGradient(
                        colors: [Color(0xff514a9d), Color(0xff24c6dc)],
                      ),
                borderRadius: isCurrentUser
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0))
                    : const BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                '$text',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
