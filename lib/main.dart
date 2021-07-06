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
import 'package:project/welcome_screen/Welcome_screen.dart';

import 'const/const.dart';
import 'screen/caht_screen.dart';

//Future<void> main() async {
//WidgetsFlutterBinding.ensureInitialized();
//final FirebaseApp app = await Firebase.initializeApp();
//runApp(ProviderScope(child: MyApp(app: app)));
//}
/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  runApp(ProviderScope(child: Welcome(app: app)));
}

 */

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  runApp(ProviderScope(
      child: MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "App",
    home: MyApp(app: app),
  )));
}

class MyApp extends StatelessWidget {
  FirebaseApp app;

  MyApp({this.app});

  @override
  Widget build(BuildContext context) {
    // new scafold
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Spacer(flex: 2),
            Image.asset("assets/images/welcome_image.png"),
            Spacer(flex: 3),
            Text(
              "Welcome to our freedom \nmessaging app",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.blueAccent),
            ),
            Spacer(),
            Text(
              "Freedom talk any person of your \nmother language.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            Spacer(flex: 3),
            FittedBox(
              child: TextButton(
                  onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Welcome(),
                        ),
                      ),
                  child: Row(
                    children: [
                      Text("Skip",
                          style: TextStyle(fontSize: 15.0, color: Colors.red)),
                      SizedBox(width: kDefaultPadding / 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.red,
                        size: 16,
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );

    /*
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

       */
  }
}

/*
  DatabaseReference _peopleref, _chatlistref;
  FirebaseDatabase database;
  bool isUserInit = false;

  User_Model userLogged;

  final List<Tab> tabs = <Tab>[
    Tab(icon: Icon(Icons.chat), text: "chat"),
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

 */
/*
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
*/

/*
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

 */
/*
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
*/
/* void Toast() {
    Fluttertoast.showToast(
        msg: "This is Toast messaget",
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5);
  }

  */
//}
