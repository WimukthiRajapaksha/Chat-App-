import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String enteredMessage = "";
  final _controller = new TextEditingController();

  void sendNewMessage() async {
    FocusScope.of(context).unfocus();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userData =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    FirebaseFirestore.instance.collection("chat").add({
      "text": this.enteredMessage,
      "createdAt": Timestamp.now(),
      "userId": userId,
      "userName": userData["userName"],
      "userImage": userData["profileImage"]
    });
    this._controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              controller: this._controller,
              decoration: InputDecoration(labelText: "Send a message.."),
              onChanged: (value) {
                setState(() {
                  this.enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed:
                (enteredMessage.trim().isEmpty) ? null : this.sendNewMessage,
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
