import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

final _firestore = FirebaseFirestore.instance;
User loggdinUser;
bool isMe;

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  String message;
  File imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final User = await _auth.currentUser;
      if (User != null) {
        loggdinUser = User;
        print(loggdinUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        print("Img name is : " + imageFile.uri.toString());
        UploadImage();
      }
    });
  }

  Future UploadImage() async {
    String Filename = Uuid().v1();
    print("name of file" + Filename);

    var ref = FirebaseStorage.instance.ref('images').child("$Filename.jpg");

    var uploadTask = await ref.putFile(imageFile);
    String ImageUrl = await uploadTask.ref.getDownloadURL();
    print("live img url is : " + ImageUrl);
    _firestore.collection('messages').add({
      'text': ImageUrl,
      'sender': loggdinUser.email,
      'type': 'img',
      'time': DateTime.now().microsecondsSinceEpoch.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0))),
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_backspace_rounded,
              color: Colors.blue, size: 35.0),
        ),
        title: Text(
          'Flash Chat',
          style: TextStyle(
              fontFamily: 'Comfortaa', fontSize: 20.0, color: Colors.black),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/White_10185.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStreme(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        getImage();
                      });
                    },
                    child: Text(
                      'Image',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      //User.email + message
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': message,
                        'sender': loggdinUser.email,
                        'type': 'text',
                        'time':
                            DateTime.now().microsecondsSinceEpoch.toString(),
                      });
                    },
                    child: Text(
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

class MessageStreme extends StatefulWidget {
  @override
  _MessageStremeState createState() => _MessageStremeState();
}

class _MessageStremeState extends State<MessageStreme> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy("time").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<BubbleDesign> messageWidgets = [];
        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];
          final messageType = message['type'];

          final currentUser = loggdinUser.email;

          if (messageType == 'text') {
            final messageWidget = BubbleDesign(
              text: messageText,
              sender: messageSender,
              type: 'text',
              isMe: currentUser == messageSender,
            );
            messageWidgets.add(messageWidget);
          } else {
            final messageWidget = BubbleDesign(
              text: messageText,
              sender: messageSender,
              type: 'img',
              isMe: currentUser == messageSender,
            );
            messageWidgets.add(messageWidget);
          }
        }
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: ListView(
              reverse: true,
              children: messageWidgets,
            ),
          ),
        );
      },
    );
  }
}

class BubbleDesign extends StatelessWidget {
  BubbleDesign({this.text, this.sender, this.isMe, this.type});

  final String text;
  final String sender;
  final String type;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    if (type == 'text') {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 4),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: TextStyle(
                  fontSize: 10, color: isMe ? Colors.white : Colors.grey),
            ),
            Material(
              elevation: 5,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))
                  : BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
              color: isMe ? Colors.white : Colors.lightBlueAccent,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  text,
                  style: TextStyle(color: isMe ? Colors.black : Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 4),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                sender,
                style: TextStyle(
                    fontSize: 10, color: isMe ? Colors.white : Colors.grey),
              ),
              Material(
                elevation: 5,
                borderRadius: isMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))
                    : BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                color: isMe ? Colors.white : Colors.lightBlueAccent,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Image.network(text),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
