import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;
  final String userName;
  final String userImage;

  MessageBubble({
    required this.key,
    required this.userName,
    required this.message,
    required this.userImage,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              this.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: this.isMe
                      ? Colors.grey[400]
                      : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft:
                          this.isMe ? Radius.circular(12) : Radius.circular(0),
                      bottomRight: this.isMe
                          ? Radius.circular(0)
                          : Radius.circular(12))),
              width: 250,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    this.userName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMe
                            ? Colors.black
                            : Theme.of(context).accentTextTheme.title!.color),
                  ),
                  Text(
                    message,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: this.isMe
                            ? Colors.black
                            : Theme.of(context).textTheme.title!.color),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: this.isMe ? null : 240,
          right: this.isMe ? 240 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(this.userImage),
          ),
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
