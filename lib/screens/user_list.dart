// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// final _firestore = FirebaseFirestore.instance;
//
// class UserList extends StatefulWidget {
//   @override
//   _UserListState createState() => _UserListState();
// }
//
// class _UserListState extends State<UserList> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore.collection('messages').orderBy("time").snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(
//               backgroundColor: Colors.blueAccent,
//             ),
//           );
//         }
//         final messages = snapshot.data.docs.[index].data['id'];
//         List<Widget> UserListWidgets = [];
//         for (var message in messages) {
//           final messageText = message['text'];
//           final messageSender = message['sender'];
//
//           final currentUser = loggdinUser.email;
//
//           final messageWidget = BubbleDesign(
//             text: messageText,
//             sender: messageSender,
//             isMe: currentUser == messageSender,
//           );
//           messageWidgets.add(messageWidget);
//         }
//         return Expanded(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//             child: ListView(
//               reverse: true,
//               children: messageWidgets,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
