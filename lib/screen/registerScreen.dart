// @dart=2.9
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:project/const/const.dart';
import 'package:project/model/user_model.dart';
import 'package:project/utils/utils.dart';

class RegisterScreen extends StatelessWidget {
  FirebaseApp app;
  User user;

  RegisterScreen({this.app, this.user});

  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Register"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: TextField(
                        keyboardType: TextInputType.name,
                        controller: _firstNameController,
                        decoration: InputDecoration(hintText: 'Last name '),
                      )),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      flex: 1,
                      child: TextField(
                        keyboardType: TextInputType.name,
                        controller: _lastNameController,
                        decoration: InputDecoration(hintText: 'Last name '),
                      ))
                ],
              ),
              TextField(
                readOnly: true,
                controller: _phoneController,
                decoration:
                    InputDecoration(hintText: user.phoneNumber ?? 'Null'),
              ),
              Row(mainAxisSize: MainAxisSize.max, children: [
                RaisedButton(
                  color: Colors.deepOrange,
                  onPressed: () {
                    if (_firstNameController == null ||
                        _firstNameController.text.isEmpty)
                      showOnlySnackBar(context, 'enter first name, please');
                    else if (_lastNameController == null ||
                        _lastNameController.text.isEmpty)
                      showOnlySnackBar(context, 'enter last name, please');
                    else {
                      User_Model userModel = new User_Model(
                          firestName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          phone: user.phoneNumber);

                      //submit on firebase
                      FirebaseDatabase(app: app)
                          .reference()
                          .child(PEOPLE_REF)
                          .child(user.uid)
                          .set(<String, dynamic>{
                        'firstName': userModel.firestName,
                        'lastName': userModel.lastName,
                        'phone': userModel.phone
                      }).then((value) {
                        showOnlySnackBar(context, 'Register success');
                        Navigator.pop(context);
                      }).catchError((e) => showOnlySnackBar(context, '$e'));
                    }
                  },
                  child: Container(
                    child: Text(
                      'Register here',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ])
            ],
          ),
        ));
  }
}
