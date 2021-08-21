import 'dart:convert';
import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final chats = snapshot.data.docs;
          // return FutureBuilder(
          //   future: FirebaseAuth.instance.currentUser,
          //   builder: (BuildContext context, AsyncSnapshot snapshot) {
          //     return ListView.builder(
          //       reverse: true,
          //       itemCount: chats.length,
          //       itemBuilder: (ctx, i) => MessageBubble(message: chats[i]["text"], isMe: chats[i]["userId"] == snapshot.data.uid,));
          //   },
          // );
          // final qu = QuerySnapshot snapshot;
          return ListView.builder(
            reverse: true,
            itemCount: chats.length,
            itemBuilder: (ctx, i) => MessageBubble(
              key: ValueKey(chats[i].id),
              userName: chats[i]["userName"],
              message: chats[i]["text"],
              userImage: chats[i]["userImage"],
              isMe: (chats[i]["userId"] ==
                  FirebaseAuth.instance.currentUser!.uid),
            ),
          );
        }
      },
    );
  }
}
