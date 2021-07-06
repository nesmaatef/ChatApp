// @dart=2.9

import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:page_transition/page_transition.dart';
import 'package:project/firebase_utils/firebase_utils.dart';
import 'package:project/model/user_model.dart';
import 'package:project/screen/registerScreen.dart';
import 'package:project/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:project/const/const.dart';
import 'package:project/screen/caht_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  runApp(ProviderScope(child: Welcome(app: app)));
}

class Welcome extends StatelessWidget {
  //236 final Future<FirebaseApp> app1 = Firebase.initializeApp();

  FirebaseApp app;

  Welcome({this.app});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/register':
            return PageTransition(
                child: RegisterScreen(
                  app: app,
                  user: FirebaseAuth.FirebaseAuth.instance.currentUser ?? null,
                ),
                type: PageTransitionType.fade,
                settings: settings);

            break;
          case '/detail':
            return PageTransition(
                child: DetailScreen(
                  app: app,
                  user: FirebaseAuth.FirebaseAuth.instance.currentUser ?? null,
                ),
                type: PageTransitionType.fade,
                settings: settings);

            break;
          default:
            return null;
        }
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', app: app),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.app}) : super(key: key);
  final FirebaseApp app;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  DatabaseReference _peopleref, _chatlistref;
  FirebaseDatabase database;
  bool isUserInit = false;

  User_Model userLogged;

  final List<Tab> tabs = <Tab>[
    Tab(
      icon: Icon(Icons.chat),
      text: "chat",
    ),
    Tab(icon: Icon(Icons.people), text: "friend")
  ];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    database = FirebaseDatabase(app: widget.app);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      processLogin(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          bottom: new TabBar(
            isScrollable: false,
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            tabs: tabs,
            controller: _tabController,
          ),
        ),
        body: isUserInit
            ? TabBarView(
                controller: _tabController,
                children: tabs.map((Tab tab) {
                  if (tab.text == 'chat')
                    return loadChatList(database, _chatlistref);
                  else
                    return loadPeople(database, _peopleref);
                }).toList(),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  void processLogin(BuildContext context) async {
    Toast();
    var user = FirebaseAuth.FirebaseAuth.instance.currentUser;
    if (user == null) {
      FirebaseAuthUi.instance()
          .launchAuth([AuthProvider.phone()]).then((fbUser) async {
        await _checkLoginState(context);
      }).catchError((e) {
        if (e is PlatformException) {
          if (e.code == FirebaseAuthUi.kUserCancelledError)
            showOnlySnackBar(context, 'user cancelled login');
          else
            showOnlySnackBar(context, '${e.message ?? 'unk error'}');
        }
      });
    } else
      await _checkLoginState(context);
  }

  Future<FirebaseAuth.User> _checkLoginState(BuildContext context) async {
    Toast();
    if (FirebaseAuth.FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.FirebaseAuth.instance.currentUser
          .getIdToken()
          .then((token) async {
        _peopleref = database.reference().child(PEOPLE_REF);
        _chatlistref = database
            .reference()
            .child(CHATLIST_REF)
            .child(FirebaseAuth.FirebaseAuth.instance.currentUser.uid);

        //load information
        _peopleref
            .child(FirebaseAuth.FirebaseAuth.instance.currentUser.uid)
            .once()
            .then((snapshot) {
          if (snapshot != null && snapshot.value != null) {
            setState(() {
              isUserInit = true;
            });
          } else {
            setState(() {
              isUserInit = true;
            });
            Navigator.pushNamed(context, "/register");
          }
        });
      });
    }
    return FirebaseAuth.FirebaseAuth.instance.currentUser;
  }

  void Toast() {
    Fluttertoast.showToast(
        msg: "This is Toast messaget",
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5);
  }
}
