import 'dart:io';

import 'package:colaborez/shared/shared.dart';
import 'package:colaborez/ui/pages/pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void enablePlatformOverrideForDesktop(){
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() async{
  // ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  enablePlatformOverrideForDesktop();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Colaborez",
      theme: lightTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        Splash.routeName : (context) => Splash(),
        Login.routeName : (context) => Login(),
        Register.routeName : (context) => Register(),
        CompleteRegister.routeName : (context) => CompleteRegister(),
        MainMenu.routeName : (context) => MainMenu(),
        //main
        AddPost.routeName : (context) => AddPost(),
        //detail
        DetailPost.routeName : (context) => DetailPost(),
        JoinIdea.routeName : (context) => JoinIdea(),
        MyIdeas.routeName : (context) => MyIdeas(),
        MyDetailPost.routeName : (context) => MyDetailPost(),
        EditPost.routeName : (context) => EditPost(),
        ProfileSettings.routeName : (context) => ProfileSettings(),
        EditProfile.routeName : (context) => EditProfile(),
        Participants.routeName : (context) => Participants(),
        ProfileInfo.routeName : (context) => ProfileInfo(),
        OtherUser.routeName : (context) => OtherUser(),
      },
    );
  }
}