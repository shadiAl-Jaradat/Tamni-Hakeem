import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_and_hypertension/UI/doctor/main_screens/lstOfMyPatient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Service/firebase_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'UI/patient/helper_page_blood.dart';
import 'UI/patient/main_screens/diabetes_screens/bottom_bar_home.dart';
import 'UI/user_type.dart';

//TODO: put home screen of patent
// import 'package:new_3ala5er/core/screens/patient/bar.dart';

//TODO: put home screen of doctor
// import 'core/screens/doctor/lstOfMyPatient.dart';

//TODO: put user type screen of doctor
//import 'core/screens/usertype.dart';

//TODO: call firebase screen from service dir
// import 'core/service/firebase.service.dart';

late String one;
late String two;
late String three;
late String four;
bool oldPA = false;

int customWeekday(DateTime dateTime) {
  int weekday = dateTime.weekday;

  if (weekday == 6) {
    return 1; // Saturday becomes 1
  } else if (weekday == 7) {
    return 2; // Sunday becomes 2
  } else {
    return weekday + 2; // Shift the other days by two
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserSimplePreferencesUser.init();
  await UserSimplePreferencesDoctorID.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cloudbase',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey, primaryColor: Colors.blueGrey),
      // home: AnimatedSplashScreen(
      //   splash: 'images/launchLogo.jpeg',
      //   duration: 2000,
      //   splashIconSize: 400,
      //   nextScreen: signin(),
      //   splashTransition: SplashTransition.scaleTransition,
      // ),
      home: signin(),
      // replace user to  barhome => shady & yazan
      // replace user to  patient => razan
      initialRoute: '/',
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

//when we are finished with this class we should copy it to authservive.dart
class signin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return AppUser();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) {
      print("new");
      return AppUser();
    } else {
      print("old  & user type is : " +
          UserSimplePreferencesDoctorID.geUserType().toString());
      if (UserSimplePreferencesDoctorID.geUserType() == 'Pa') {
        oldPA = true;
        one = UserSimplePreferencesUser.getUserID() ?? '';
        two = UserSimplePreferencesDoctorID.getDrID() ?? '';
        three = UserSimplePreferencesUser.getPaName() ?? '';
        four =
            UserSimplePreferencesUser.getLastOpen() ?? 'this is the first time';
        print("***** old");
        print('***** userID : ' + one);
        print('***** DrID : ' + two);
        print('***** userName : ' + three);
        print('***** last open : ' + four);
        return BarHome();
      } else if (UserSimplePreferencesDoctorID.geUserType() == 'Dr') {
        one = UserSimplePreferencesDoctorID.getDrName() ?? '';
        two = UserSimplePreferencesDoctorID.getDrID() ?? '';
        print("***** Dr Name :  " + one);
        print("***** Dr ID :  " + two);
        return ListOfPatient();
        //return AppUser();
      } else {
        return AppUser();
      }
    }
  }
}

