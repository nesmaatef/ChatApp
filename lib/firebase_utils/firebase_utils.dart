// @dart=2.9
import 'dart:convert';

import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/const/const.dart';
import 'package:project/main.dart';
import 'package:project/model/chat_info.dart';
import 'package:project/model/user_model.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:project/state/state_manager.dart';
import 'package:project/utils/time_ago.dart';
import 'package:project/utils/utils.dart';

Widget loadChatList(FirebaseDatabase database, DatabaseReference chatlistref) {
  return StreamBuilder(
      stream: chatlistref.onValue,
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
        if (snapshot.hasData) {
          List<ChatInfo> chatinfos = new List<ChatInfo>();
          Map<dynamic, dynamic> values = snapshot.data.snapshot.value;

          if (values != null) {
            values.forEach((key, value) {
              var chatInfo = ChatInfo.fromJson(json.decode(json.encode(value)));
              chatinfos.add(chatInfo);
            });
          }
          return ListView.builder(
              itemCount: chatinfos.length,
              itemBuilder: (context, index) {
                var displayname =
                    FirebaseAuth.FirebaseAuth.instance.currentUser.uid ==
                            chatinfos[index].createId
                        ? chatinfos[index].friendName
                        : chatinfos[index].createName;
                return Consumer(builder: (context, watch, _) {
                  return GestureDetector(
                      onTap: () {
                        database
                            .reference()
                            .child(PEOPLE_REF)
                            .child(FirebaseAuth.FirebaseAuth.instance
                                        .currentUser.uid ==
                                    chatinfos[index].createId
                                ? chatinfos[index].friendId
                                : chatinfos[index].createId)
                            .once()
                            .then((DataSnapshot snapshot) {
                          if (snapshot != null) {
                            User_Model userModel = User_Model.fromJson(
                                json.decode(json.encode(snapshot.value)));
                            userModel.uid = snapshot.key;
                            context.read(chatUser).state = userModel;

                            database
                                .reference()
                                .child(PEOPLE_REF)
                                .child(FirebaseAuth
                                    .FirebaseAuth.instance.currentUser.uid)
                                .once()
                                .then((value) {
                              User_Model currentusermodel = User_Model.fromJson(
                                  json.decode(json.encode(value.value)));
                              currentusermodel.uid = value.key;
                              context.read(userLogged).state = currentusermodel;
                              Navigator.pushNamed(context, "/detail");
                            }).catchError((e) => showOnlySnackBar(
                                    context, 'cannot load user information '));
                          }
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                              '${TimeAgo.timeAgoSinceDate(chatinfos[index].lastUpdate)}'),
                          ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/user_3.png"),
                                // backgroundColor: Colors.primaries[
                                //   Random().nextInt(Colors.primaries.length)],
                                child: Text('${displayname.substring(0, 1)}',
                                    style: TextStyle(color: Colors.black87)),
                              ),
                              title: Text('${displayname}',
                                  style: TextStyle(color: Colors.black87)),
                              subtitle: Text('${chatinfos[index].lastMessage}'),
                              isThreeLine: true),
                          Divider(
                            thickness: 2,
                          )
                        ],
                      ));
                });
              });
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      });
}

Widget loadPeople(FirebaseDatabase database, DatabaseReference _peopleref) {
  return StreamBuilder(
      stream: _peopleref.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<User_Model> usermodels = new List<User_Model>();
          Map<dynamic, dynamic> values = snapshot.data.snapshot.value;
          values.forEach((key, value) {
            if (key != FirebaseAuth.FirebaseAuth.instance.currentUser.uid) {
              var usermodel =
                  User_Model.fromJson(json.decode(json.encode(value)));
              usermodel.uid = key;
              usermodels.add(usermodel);
            }
          });
          return ListView.builder(
              itemCount: usermodels.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      database
                          .reference()
                          .child(PEOPLE_REF)
                          .child(FirebaseAuth
                              .FirebaseAuth.instance.currentUser.uid)
                          .once()
                          .then((value) {
                        User_Model currentusermodel = User_Model.fromJson(
                            json.decode(json.encode(value.value)));
                        currentusermodel.uid = value.key;
                        context.read(userLogged).state = currentusermodel;
                        context.read(chatUser).state = usermodels[index];
                        Navigator.pushNamed(context, "/detail");
                      });
                    },
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/user_3.png"),
                            //  backgroundColor: Colors.primaries[
                            //    Random().nextInt(Colors.primaries.length)],
                          ),
                          title: Text(
                              '${usermodels[index].firestName} ${usermodels[index].lastName}',
                              style: TextStyle(color: Colors.black87)),
                          subtitle: Text(
                            '${usermodels[index].phone}',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        )
                      ],
                    ));
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      });
}
