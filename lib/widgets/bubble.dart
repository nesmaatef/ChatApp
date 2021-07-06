import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/model/chat_message.dart';
import 'package:project/utils/time_ago.dart';

Widget bubbleTextFromUser(ChatMessage chatcontent) {
  return Column(
    children: [
      TimeAgo.isSameDay(chatcontent.timeStamp)
          ? Container()
          : Text(
              '${TimeAgo.timeAgoSinceDate(chatcontent.timeStamp)}',
              style:
                  TextStyle(fontStyle: FontStyle.italic, color: Colors.black87),
            ),
      Bubble(
        margin: const BubbleEdges.only(top: 10.0),
        alignment: Alignment.topRight,
        nip: BubbleNip.rightBottom,
        color: Colors.black87,
        child: Text('${chatcontent.content}',
            style: TextStyle(color: Colors.white), textAlign: TextAlign.right),
      )
    ],
  );
}

Widget bubbleTextFromFriend(ChatMessage chatcontent) {
  return Column(children: [
    TimeAgo.isSameDay(chatcontent.timeStamp)
        ? Container()
        : Text(
            '${TimeAgo.timeAgoSinceDate(chatcontent.timeStamp)}',
            style:
                TextStyle(fontStyle: FontStyle.italic, color: Colors.black87),
          ),
    Bubble(
      margin: const BubbleEdges.only(top: 10.0),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftBottom,
      color: Colors.yellow,
      child: Text('${chatcontent.content}',
          style: TextStyle(color: Colors.pink), textAlign: TextAlign.left),
    )
  ]);
}

Widget bubbleImageFromUser(ChatMessage chatcontent) {
  return Column(
    children: [
      TimeAgo.isSameDay(chatcontent.timeStamp)
          ? Container()
          : Text(
              '${TimeAgo.timeAgoSinceDate(chatcontent.timeStamp)}',
              style:
                  TextStyle(fontStyle: FontStyle.italic, color: Colors.black87),
            ),
      Bubble(
          margin: const BubbleEdges.only(top: 10.0),
          alignment: Alignment.topRight,
          nip: BubbleNip.leftBottom,
          color: Colors.yellow,
          child: Column(
            children: [
              Image.network(chatcontent.pictureLink),
              Text('${chatcontent.content}',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.left),
            ],
          ))
    ],
  );
}

Widget bubbleImageFromFriend(ChatMessage chatcontent) {
  return Column(
    children: [
      TimeAgo.isSameDay(chatcontent.timeStamp)
          ? Container()
          : Text(
              '${TimeAgo.timeAgoSinceDate(chatcontent.timeStamp)}',
              style:
                  TextStyle(fontStyle: FontStyle.italic, color: Colors.black87),
            ),
      Bubble(
          margin: const BubbleEdges.only(top: 10.0),
          alignment: Alignment.topLeft,
          nip: BubbleNip.leftBottom,
          color: Colors.yellow,
          child: Column(
            children: [
              Image.network(chatcontent.pictureLink),
              Text('${chatcontent.content}',
                  style: TextStyle(color: Colors.pink),
                  textAlign: TextAlign.left),
            ],
          ))
    ],
  );
}
