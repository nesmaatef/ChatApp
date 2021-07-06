// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:project/const/const.dart';
import 'package:project/model/chat_info.dart';
import 'package:project/model/chat_message.dart';
import 'package:project/state/state_manager.dart';
import 'package:project/utils/utils.dart';
import 'package:project/widgets/bubble.dart';

class DetailScreen extends ConsumerWidget {
  DetailScreen({this.app, this.user});
  FirebaseApp app;
  User user;
  DatabaseReference offsetRef, chatRef;
  FirebaseDatabase database;
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var friendUser = watch(chatUser).state;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${friendUser.firestName} '),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: friendUser.uid != null
                    ? FirebaseAnimatedList(
                        controller: _scrollController,
                        sort: (DataSnapshot a, DataSnapshot b) =>
                            b.key.compareTo(a.key),
                        reverse: true,
                        query: loadChatContent(context, app),
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index) {
                          var ChatContent = ChatMessage.fromjson(
                              json.decode(json.encode(snapshot.value)));
                          return SizeTransition(
                            sizeFactor: animation,
                            child: ChatContent.picture
                                ? ChatContent.senderId == user.uid
                                    ? bubbleImageFromUser(ChatContent)
                                    : bubbleImageFromFriend(ChatContent)
                                : ChatContent.senderId == user.uid
                                    ? bubbleTextFromUser(ChatContent)
                                    : bubbleTextFromFriend(ChatContent),
                          );
                        })
                    : Center(child: CircularProgressIndicator()),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        decoration:
                            InputDecoration(hintText: 'Enter your message'),
                        controller: _textEditingController,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        offsetRef.once().then((DataSnapshot snapshot) {
                          var offset = snapshot.value as int;
                          var estimatedServerTimeInMs =
                              DateTime.now().millisecondsSinceEpoch + offset;

                          submitChat(context, estimatedServerTimeInMs);
                        });
                        // auto scroll chat layout to end
                        autoScroll(_scrollController);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  loadChatContent(BuildContext context, FirebaseApp app) {
    database = FirebaseDatabase(app: app);
    offsetRef = database.reference().child('.info/serverTimeOffset');
    chatRef = database
        .reference()
        .child(CHAT_REF)
        .child(getRoomId(user.uid, context.read(chatUser).state.uid))
        .child(DETAIL_REF);

    return chatRef;
  }

  void submitChat(BuildContext context, int estimatedServerTimeInMs) {
    ChatMessage chatMessage = ChatMessage();
    chatMessage.name = creatname(context.read(userLogged).state);
    chatMessage.content = _textEditingController.text;
    chatMessage.timeStamp = estimatedServerTimeInMs;
    chatMessage.senderId = user.uid;
    chatMessage.picture = false;
    submitChatToFirebase(context, chatMessage, estimatedServerTimeInMs);
  }

  void submitChatToFirebase(BuildContext context, ChatMessage chatMessage,
      int estimatedServerTimeInMs) {
    chatRef.once().then((DataSnapshot snapshot) {
      if (snapshot != null)
        creatChat(context, chatMessage, estimatedServerTimeInMs);
    });
  }

  void creatChat(BuildContext context, ChatMessage chatMessage,
      int estimatedServerTimeInMs) {
    ChatInfo chatInfo = new ChatInfo(
      createId: user.uid,
      friendName: creatname(context.read(chatUser).state),
      friendId: context.read(chatUser).state.uid,
      createName: creatname(context.read(userLogged).state),
      lastMessage: chatMessage.picture ? "<Image>" : chatMessage.content,
      lastUpdate: DateTime.now().millisecondsSinceEpoch,
      createDate: DateTime.now().millisecondsSinceEpoch,
    );
    // add to firebase
    database
        .reference()
        .child(CHATLIST_REF)
        .child(user.uid)
        .child(context.read(chatUser).state.uid)
        .set(<String, dynamic>{
      'lastUpdate': chatInfo.lastUpdate,
      'lastMessage': chatInfo.lastMessage,
      'createId': chatInfo.createId,
      'friendId': chatInfo.friendId,
      'createName': chatInfo.createName,
      'friendName': chatInfo.friendName,
      'createDate': chatInfo.createDate
    }).then((value) {
      // after success ,copy to friend chat list
      database
          .reference()
          .child(CHATLIST_REF)
          .child(context.read(chatUser).state.uid)
          .child(user.uid)
          .set(<String, dynamic>{
        'lastUpdate': chatInfo.lastUpdate,
        'lastMessage': chatInfo.lastMessage,
        'createId': chatInfo.createId,
        'friendId': chatInfo.friendId,
        'createName': chatInfo.createName,
        'friendName': chatInfo.friendName,
        'createDate': chatInfo.createDate
      }).then((value) {
        //after success , add on chat reference
        chatRef.push().set(<String, dynamic>{
          'uid': chatMessage.uid,
          'name': chatMessage.name,
          'content': chatMessage.content,
          'pictureLink': chatMessage.pictureLink,
          'picture': chatMessage.picture,
          'senderId': chatMessage.senderId,
          'timeStamp': chatMessage.timeStamp,
        }).then((value) {
          //clear text content
          _textEditingController.text = '';

          //auto scroll
          autoScroll(_scrollController);
        }).catchError(
            (e) => showOnlySnackBar(context, 'Erorr can\'t submit  chat List'));
      }).catchError((e) => showOnlySnackBar(
              context, 'Erorr can\'t submit friend chat List'));
    }).catchError((e) =>
            showOnlySnackBar(context, 'Erorr can\'t submit user chat List'));
  }
}
