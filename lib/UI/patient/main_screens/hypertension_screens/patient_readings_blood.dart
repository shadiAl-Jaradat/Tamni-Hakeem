import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:diabetes_and_hypertension/Service/firebase_service.dart';
import 'package:diabetes_and_hypertension/UI/loading.dart';
import 'package:diabetes_and_hypertension/UI/patient/dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../check_box_commitment.dart';
import '../../helper_page_blood.dart';


FirebaseServiceDoctor doctor = FirebaseServiceDoctor();

class PatientInformationBlood extends StatefulWidget {
  const PatientInformationBlood({super.key});

  @override
  _PatientInformationBloodState createState() => _PatientInformationBloodState();
}

int globalCounterOfWeek = 0;
bool theDateChecked = false;
DateTime dt = DateTime.now();
String amPm = intl.DateFormat('a').format(dt);
intl.DateFormat formatter = intl.DateFormat('dd-MM-yyyy');
DateTime day = DateTime.now();
intl.DateFormat ww = intl.DateFormat('EEEE');
int currentReadingsCounter = 0;
int currentCommitmentCounter = 0;

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

Future<void> checkDate(DateTime lastOpen, int counterOfWeek) async{

  theDateChecked = true;
  /// 1st step :
  if (UserSimplePreferencesUser.getLastOpen() == null) return;
  DateTime currentOpen = DateTime.now();
  int difference = currentOpen.difference(lastOpen).inDays;
  //int difference = 8;

  if (difference >= 7) {
    //set new last open
    UserSimplePreferencesUser.setLastOpen(DateTime.now().toString());

    //TODO: counter of week ++ on shared pref and firebase
    UserSimplePreferencesUser.setCtOfWeek(
        (counterOfWeek + ((difference/7).floor()))
            .toString());

    await FirebaseFirestore.instance
        .collection('/patient')
        .doc(UserSimplePreferencesUser.getUserID() ?? uid).set({
      'counterOfWeeks': (counterOfWeek + ((difference/7).floor())),
    }, SetOptions(merge: true));
    //TODO:  connect this with if user has blood and has Diabetes
    globalCounterOfWeek = int.parse(UserSimplePreferencesUser.getCtOfWeek() ?? counterOfWeek.toString());
    await createNewBloodWeek();
    await createNewDiabetesWeek();
  }
  else if(( difference < 7 && customWeekday(currentOpen) < customWeekday(lastOpen)) ){
    UserSimplePreferencesUser.setLastOpen(DateTime.now().toString());



    //TODO: counter of week ++ on shared pref and firebase
    UserSimplePreferencesUser.setCtOfWeek((counterOfWeek + 1).toString());

    await FirebaseFirestore.instance
        .collection('/patient')
        .doc(UserSimplePreferencesUser.getUserID() ?? uid).set({
      'counterOfWeeks': (counterOfWeek + 1),
    }, SetOptions(merge: true));
    //TODO:  connect this with if user has blood and has Diabetes
    globalCounterOfWeek = int.parse(UserSimplePreferencesUser.getCtOfWeek() ?? counterOfWeek.toString());
    await createNewBloodWeek();
    await createNewDiabetesWeek();
  }
}

CollectionReference users = FirebaseFirestore.instance
    .collection('/patient');

String namePA = UserSimplePreferencesUser.getPaName() ?? "name";
String userID = UserSimplePreferencesUser.getUserID() ?? '';
late DateTime lastOpenFromFireBase;
Future<DocumentSnapshot<Object?>>? getInitData() async {

  DocumentSnapshot<Map<String, dynamic>> dd  = await FirebaseFirestore.instance
      .collection('/patient')
      .doc(userID)
      .get();
  Map<String, dynamic> data = dd.data() as Map<String, dynamic>;
  namePA = data['Name'];
  lastOpenFromFireBase = data['lastOpen'].toDate();
  globalCounterOfWeek = data['counterOfWeeks'];

  currentReadingsCounter = data['readingsCounter'];
  currentCommitmentCounter = data['commitmentCounter'];
  UserSimplePreferencesUser.setPaName(namePA);

  if(theDateChecked == false){
    await checkDate(lastOpenFromFireBase, globalCounterOfWeek);
    await UserSimplePreferencesUser.setCtOfWeek(globalCounterOfWeek.toString());
  }

  DocumentSnapshot readingsData = await users
      .doc(userID)
      .collection('/bloodWeeks')
      .doc(UserSimplePreferencesUser.getCtOfWeek() ?? "0")
      .get();

  await FirebaseFirestore.instance
      .collection('/patient')
      .doc(userID).set({
    'lastOpen': DateTime.now(),
  }, SetOptions(merge: true));

  return readingsData;
}

class _PatientInformationBloodState extends State<PatientInformationBlood> {
  final _readingDiastolic = TextEditingController();
  final _readingSystolic = TextEditingController();
  final _readingHartRate = TextEditingController();

  String amPmFormat = intl.DateFormat('a').format(DateTime.now());
  late double screenHeight;
  late double screenWidth;
  late double textScale;
  bool loading = true;

  late double morningDiastolic;
  late double morningSystolic;
  late double morningHartRate;

  late double eveningDiastolic;
  late double eveningSystolic;
  late double eveningHartRate;

  late int tag;
  late String period;
  late String cardDay;
  late String amPm;
  late String wa2t;
  late String arabicDay;
  late String englishDay;



  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    textScale = MediaQuery.of(context).textScaleFactor;
    if (kDebugMode) {
      print("text scale : ");
    }
    if (kDebugMode) {
      print(textScale);
    }



    bool isCommitment = false;
    return FutureBuilder<DocumentSnapshot>(
      future: getInitData(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.data == null) return const Loading();

        if (snapshot.hasError) {
          return const Text("ERROR");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("ERROR");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          return Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              height: screenHeight,
              width: screenWidth,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /// welcome statement with name of user
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25.0),
                        child: Center(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: SvgPicture.asset(
                                  'images/newprofile.svg',
                                  height: screenHeight * 0.09,
                                  width: screenHeight * 0.09,
                                  color: const Color.fromRGBO(117, 121, 122, 1),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'مرحبا',
                                      style: GoogleFonts.tajawal(
                                          fontSize: 0.05 * screenWidth,
                                          color: const Color.fromRGBO(139, 139, 139, 1)),
                                    ),
                                    Text(
                                      namePA,
                                      style: GoogleFonts.tajawal(
                                          fontSize: 0.055 * screenWidth,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      ///Tow buttons "morning" & "after"
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.06),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: [
                                Text(
                                  'أضف قراءة',
                                  style: GoogleFonts.tajawal(
                                      fontSize: 0.04 * screenWidth,
                                      color: const Color(0xff0B3C42)
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:10.0),
                                  child: Text(
                                    'صباحاً',
                                    style: GoogleFonts.tajawal(
                                        fontSize: 0.04 * screenWidth,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff0B3C42)
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.015,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 0,
                                      shape: const CircleBorder()),
                                  onPressed: amPmFormat == 'AM' ?  () {
                                    bool isCommitment = false;
                                    setState(() {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 15, sigmaY: 15),
                                          child: Container(
                                            height: screenHeight* 0.8,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.only(
                                                    topLeft: Radius
                                                        .circular(30),
                                                    topRight:
                                                    Radius.circular(
                                                        30))),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Align(
                                                          alignment:
                                                          Alignment.topLeft,
                                                          child: Padding(
                                                              padding:
                                                              const EdgeInsets.only(left: 30.0, top: 20),
                                                              child: IconButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                        context)
                                                                        .pop(),
                                                                icon: const Icon(
                                                                  Icons.close,
                                                                  size: 27,
                                                                ),
                                                              )
                                                          )
                                                      ),
                                                      Align(
                                                          alignment:
                                                          Alignment.topRight,
                                                          child: Padding(
                                                              padding: const EdgeInsets.only(right: 30.0, top: 20),
                                                              child: IconButton(
                                                                  onPressed: (){
                                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HelperScreenBlood()));
                                                                  },
                                                                  icon: const Icon(
                                                                    Icons.help_outline_rounded,
                                                                    color: Colors.grey,
                                                                    size: 27,
                                                                  )
                                                              ),
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          bottom: 15.0),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top:5.0),
                                                        child: Text(
                                                          'ادخال القراءة صباحاً',
                                                          style: GoogleFonts.tajawal(
                                                              fontSize: 0.055 * screenWidth,
                                                              color: const Color(0xff0B3C42)
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        width: 100,
                                                        child: TextField(
                                                          textAlign:
                                                          TextAlign.center,
                                                          keyboardType:
                                                          TextInputType
                                                              .number,
                                                          controller: _readingSystolic,
                                                          decoration:
                                                          InputDecoration(
                                                            hintText: "عالي",
                                                            hintStyle: GoogleFonts.tajawal(),
                                                            contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical:
                                                                22.0),
                                                            border:
                                                            OutlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                      219,
                                                                      228,
                                                                      230,
                                                                      1),
                                                                  width: 1.5),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  18.0),
                                                            ),
                                                            enabledBorder:
                                                            OutlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(219, 228, 230, 1),
                                                                  width: 3.0),
                                                              borderRadius:
                                                              BorderRadius.circular(18.0),
                                                            ),
                                                            focusedBorder:
                                                            OutlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                  color: Color(0xff0B3C42),
                                                                  width: 3.0),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  18.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const Text("   /   ", style: TextStyle(fontSize: 25),),
                                                      SizedBox(
                                                        width: 100,
                                                        child: TextField(
                                                          textAlign: TextAlign.center,
                                                          keyboardType: TextInputType.number,
                                                          controller: _readingDiastolic,
                                                          decoration:
                                                          InputDecoration(
                                                            hintText: "واطي",
                                                            hintStyle: GoogleFonts.tajawal(),
                                                            contentPadding:
                                                            const EdgeInsets.symmetric(vertical: 22.0),
                                                            border: OutlineInputBorder(
                                                              borderSide: const BorderSide(color: Color.fromRGBO(219, 228, 230, 1), width: 1.5),
                                                              borderRadius: BorderRadius.circular(18.0),
                                                            ),
                                                            enabledBorder:
                                                            OutlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                  color: Color.fromRGBO(219, 228, 230, 1),
                                                                  width: 3.0),
                                                              borderRadius:
                                                              BorderRadius.circular(18.0),
                                                            ),
                                                            focusedBorder:
                                                            OutlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                  color: Color(0xff0B3C42),
                                                                  width: 3.0),
                                                              borderRadius:
                                                              BorderRadius.circular(18.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20,),
                                                  SizedBox(
                                                    width: 204,
                                                    child: TextField(
                                                      textAlign:
                                                      TextAlign.center,
                                                      keyboardType:
                                                      TextInputType
                                                          .number,
                                                      controller: _readingHartRate,
                                                      decoration:
                                                      InputDecoration(
                                                        hintText: "معدل ضربات القلب",
                                                        hintStyle: GoogleFonts.tajawal(),
                                                        contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical:
                                                            22.0),
                                                        border:
                                                        OutlineInputBorder(
                                                          borderSide: const BorderSide(
                                                              color: Color
                                                                  .fromRGBO(
                                                                  219,
                                                                  228,
                                                                  230,
                                                                  1),
                                                              width: 1.5),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              18.0),
                                                        ),
                                                        enabledBorder:
                                                        OutlineInputBorder(
                                                          borderSide: const BorderSide(
                                                              color: Color
                                                                  .fromRGBO(219, 228, 230, 1),
                                                              width: 3.0),
                                                          borderRadius:
                                                          BorderRadius.circular(18.0),
                                                        ),
                                                        focusedBorder:
                                                        OutlineInputBorder(
                                                          borderSide: const BorderSide(
                                                              color: Color(0xff0B3C42),
                                                              width: 3.0),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              18.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  CheckBoxCommitment(
                                                    onChanged: (bool newValue) {
                                                      setState(() {
                                                        isCommitment = newValue;
                                                      });
                                                    },
                                                    fillColor: const Color(0xff20AEC1),
                                                  ),
                                                  const SizedBox(height: 20,),
                                                  Container(
                                                      alignment:
                                                      Alignment.center,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0),
                                                        child: SizedBox(
                                                          height: 54,
                                                          child:
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                fixedSize: const Size(204, 37),
                                                                textStyle: TextStyle(fontSize: 20 * textScale),
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(52),),
                                                                backgroundColor: const Color(0xff20AEC1)
                                                            ),
                                                            onPressed: () {
                                                              print("his result for isCommitment = $isCommitment");
                                                              time(dt);
                                                              timeInEnglish(dt);
                                                              setState(() {
                                                                tag = 1;
                                                                morningSystolic = double.parse(_readingSystolic.text);
                                                                morningDiastolic = double.parse(_readingDiastolic.text);
                                                                morningHartRate = double.parse(_readingHartRate.text);

                                                                if (morningDiastolic <= 0 || morningSystolic <= 0 || morningHartRate <= 0) {
                                                                  showDialog(context: context,
                                                                      builder: (BuildContext context){
                                                                        return const CustomDialogBox();
                                                                      }
                                                                  );
                                                                } else {
                                                                  // if (oldPA == true)
                                                                  //   doctor.writeReadingsMorningOLD(
                                                                  //       data['MorningReadings'], morning,
                                                                  //       arabicDay,
                                                                  //       period,
                                                                  //       wa2t,data['Days_English_morning'],englishDay
                                                                  //   );
                                                                  // else
                                                                  writeReadingsMorning(
                                                                    newDiastolicRead: morningDiastolic,
                                                                    newSystolicRead: morningSystolic,
                                                                    newHartRateRead: morningHartRate,


                                                                    oldDiastolicReadings: data['MorningDiastolicReadings'],
                                                                    oldSystolicReadings: data['MorningSystolicReadings'],
                                                                    oldHartRateReadings: data['MorningHartRateReadings'],

                                                                    arabicDay: arabicDay,
                                                                    period: period,
                                                                    wa2t: wa2t,
                                                                    englishTime: englishDay,
                                                                    oldDays: data['Days_English_morning'],
                                                                    oldMorningDateTime: data['MorningDateTime'],
                                                                    oldMorningReadingsDateArabic: data['MorningReadingsDateArabic'],
                                                                    dateTime: DateTime.now(),
                                                                    commitmentCounter: isCommitment ? currentCommitmentCounter + 1 : currentCommitmentCounter,
                                                                    readingsCounter: currentReadingsCounter + 1,
                                                                  );
                                                                  _readingDiastolic.clear();
                                                                  _readingSystolic.clear();
                                                                  _readingHartRate.clear();
                                                                  Navigator.pop(context, morningDiastolic);

                                                                }
                                                              });
                                                            },
                                                            child: const Text(
                                                              'ادخال القراءة',
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  } : null ,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.grey.withOpacity(0.4),
                                      //     spreadRadius: 2,
                                      //     blurRadius: 10,
                                      //     offset: Offset(0, 8), // changes position of shadow
                                      //   ),
                                      // ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top:0.0),
                                      child: SvgPicture.asset(
                                        'images/addbefore.svg',
                                        height: screenHeight * 0.16,
                                        width: screenHeight * 0.16,
                                        colorFilter: amPmFormat == 'AM'  ?null :  ColorFilter.mode(
                                          Colors.white.withOpacity(0.5),
                                          BlendMode.srcATop,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // icon: Icon(Icons.add),
                                  // label: Text(''),
                                )
                              ],
                            ),
                            Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'أضف قراءة',
                                  style: GoogleFonts.tajawal(
                                      fontSize: 0.04 * screenWidth,
                                      color: const Color(0xff0B3C42)
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:10.0),
                                  child: Text(
                                    'مساءاً',
                                    style: GoogleFonts.tajawal(
                                        fontSize: 0.04 * screenWidth,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff0B3C42)
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.015,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 0,
                                      shape: const CircleBorder() //elevated btton background color
                                  ),
                                  onPressed: amPmFormat == 'PM' ?  () {
                                    setState(() {
                                      bool isCommitment = false;
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                          child: Container(
                                            height: screenHeight *0.9,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.only(
                                                    topLeft: Radius
                                                        .circular(30),
                                                    topRight:
                                                    Radius.circular(
                                                        30))),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Align(
                                                          alignment:
                                                          Alignment.topLeft,
                                                          child: Padding(
                                                              padding:
                                                              const EdgeInsets.only(left: 30.0, top: 20),
                                                              child: IconButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                        context)
                                                                        .pop(),
                                                                icon: const Icon(
                                                                  Icons.close,
                                                                  size: 27,
                                                                ),
                                                              )
                                                          )
                                                      ),
                                                      Align(
                                                          alignment:
                                                          Alignment.topRight,
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(right: 30.0, top: 20),
                                                            child: IconButton(
                                                                onPressed: (){
                                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HelperScreenBlood()));
                                                                },
                                                                icon: const Icon(
                                                                  Icons.help_outline_rounded,
                                                                  color: Colors.grey,
                                                                  size: 27,
                                                                )
                                                            ),
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                  ListTile(
                                                      title: Align(
                                                        alignment:
                                                        Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              bottom: 15.0),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 5.0),
                                                            child: Text(
                                                              'ادخال القراءة مساءاً',
                                                              style: GoogleFonts.tajawal(
                                                                  fontSize: 0.055 * screenWidth,
                                                                  color: const Color(0xff0B3C42)
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        width: 100,
                                                        child: TextField(
                                                          textAlign:
                                                          TextAlign.center,
                                                          keyboardType:
                                                          TextInputType
                                                              .number,
                                                          controller: _readingDiastolic,
                                                          decoration:
                                                          InputDecoration(
                                                            hintText: "عالي",
                                                            hintStyle: GoogleFonts.tajawal(),
                                                            contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical:
                                                                22.0),
                                                            border:
                                                            OutlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                      219,
                                                                      228,
                                                                      230,
                                                                      1),
                                                                  width: 1.5),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  18.0),
                                                            ),
                                                            enabledBorder:
                                                            OutlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(219, 228, 230, 1),
                                                                  width: 3.0),
                                                              borderRadius:
                                                              BorderRadius.circular(18.0),
                                                            ),
                                                            focusedBorder:
                                                            OutlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                  color: Color(0xff0B3C42),
                                                                  width: 3.0),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  18.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const Text("   /   ", style: TextStyle(fontSize: 25),),
                                                      SizedBox(
                                                        width: 100,
                                                        child: TextField(
                                                          textAlign: TextAlign.center,
                                                          keyboardType: TextInputType.number,
                                                          controller: _readingSystolic,
                                                          decoration:
                                                          InputDecoration(
                                                            hintText: "واطي",
                                                            hintStyle: GoogleFonts.tajawal(),
                                                            contentPadding:
                                                            const EdgeInsets.symmetric(vertical: 22.0),
                                                            border: OutlineInputBorder(
                                                              borderSide: const BorderSide(color: Color.fromRGBO(219, 228, 230, 1), width: 1.5),
                                                              borderRadius: BorderRadius.circular(18.0),
                                                            ),
                                                            enabledBorder:
                                                            OutlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                  color: Color.fromRGBO(219, 228, 230, 1),
                                                                  width: 3.0),
                                                              borderRadius:
                                                              BorderRadius.circular(18.0),
                                                            ),
                                                            focusedBorder:
                                                            OutlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                  color: Color(0xff0B3C42),
                                                                  width: 3.0),
                                                              borderRadius:
                                                              BorderRadius.circular(18.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20,),
                                                  SizedBox(
                                                    width: 204,
                                                    child: TextField(
                                                      textAlign:
                                                      TextAlign.center,
                                                      keyboardType:
                                                      TextInputType
                                                          .number,
                                                      controller: _readingHartRate,
                                                      decoration:
                                                      InputDecoration(
                                                        hintText: "معدل ضربات القلب",
                                                        hintStyle: GoogleFonts.tajawal(),
                                                        contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical:
                                                            22.0),
                                                        border:
                                                        OutlineInputBorder(
                                                          borderSide: const BorderSide(
                                                              color: Color
                                                                  .fromRGBO(
                                                                  219,
                                                                  228,
                                                                  230,
                                                                  1),
                                                              width: 1.5),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              18.0),
                                                        ),
                                                        enabledBorder:
                                                        OutlineInputBorder(
                                                          borderSide: const BorderSide(
                                                              color: Color
                                                                  .fromRGBO(219, 228, 230, 1),
                                                              width: 3.0),
                                                          borderRadius:
                                                          BorderRadius.circular(18.0),
                                                        ),
                                                        focusedBorder:
                                                        OutlineInputBorder(
                                                          borderSide: const BorderSide(
                                                              color: Color(0xff0B3C42),
                                                              width: 3.0),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              18.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  CheckBoxCommitment(
                                                    onChanged: (bool newValue) {
                                                      setState(() {
                                                        isCommitment = newValue;
                                                      });
                                                    },
                                                    fillColor: const Color(0xff167582),
                                                  ),
                                                  const SizedBox(height: 20,),
                                                  Container(
                                                    alignment:
                                                    Alignment.center,
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                          top: 20.0),
                                                      child: SizedBox(
                                                        height: 54,
                                                        child: ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                              fixedSize:
                                                              const Size(204,
                                                                  37),
                                                              textStyle: TextStyle(
                                                                  fontSize: 20 * textScale),
                                                              shape:
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius.circular(52),
                                                              ),
                                                              backgroundColor: const Color(0xff167582),
                                                            ),
                                                            onPressed: () {
                                                              print("his result for isCommitment = $isCommitment");
                                                              dt = DateTime.now();
                                                              time(dt);
                                                              timeInEnglish(dt);
                                                              setState(() {
                                                                tag = 0;
                                                                eveningDiastolic = double.parse(_readingDiastolic.text);
                                                                eveningSystolic = double.parse(_readingSystolic.text);
                                                                eveningHartRate = double.parse(_readingHartRate.text);

                                                                if (eveningDiastolic <= 0) {
                                                                  showDialog<
                                                                      String>(
                                                                    context:
                                                                    context,
                                                                    builder:
                                                                        (BuildContextcontext) =>
                                                                        AlertDialog(
                                                                          title: const Text(
                                                                              'ERROR'),
                                                                          content:
                                                                          const Text('الرقم الذي ادخلته خاطئ  , الرجاء اعادة ادخال الرقم '),
                                                                          actions: <
                                                                              Widget>[
                                                                            TextButton(
                                                                              onPressed: () =>
                                                                                  Navigator.pop(context, 'OK'),
                                                                              child:
                                                                              const Text('OK'),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                  );
                                                                } else {
                                                                  writeReadingsEvening(
                                                                    newDiastolicRead: eveningDiastolic,
                                                                    newSystolicRead: eveningSystolic,
                                                                    newHartRateRead: eveningHartRate,

                                                                    oldDiastolicReadings: data['EveningDiastolicReadings'],
                                                                    oldSystolicReadings: data['EveningSystolicReadings'],
                                                                    oldHartRateReadings: data['EveningHartRateReadings'],


                                                                    arabicDay: arabicDay,
                                                                    period: period,
                                                                    wa2t: wa2t,
                                                                    englishDay: englishDay,
                                                                    oldDays: data['Days_English_evening'],
                                                                    oldEveningDateTime: data['EveningDateTime'],
                                                                    oldEveningReadingsDateArabic: data['EveningReadingsDateArabic'],
                                                                    dateTime: DateTime.now(),

                                                                    commitmentCounter: isCommitment ? currentCommitmentCounter + 1 : currentCommitmentCounter,
                                                                    readingsCounter: currentReadingsCounter+1,
                                                                  );
                                                                  _readingDiastolic.clear();
                                                                  _readingSystolic.clear();
                                                                  _readingHartRate.clear();
                                                                  Navigator.pop(context);
                                                                }
                                                              });
                                                            },
                                                            child: Text(
                                                              'ادخال القراءة ',
                                                              textAlign: TextAlign.center,
                                                              style: GoogleFonts.tajawal(),
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  } : null,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: SvgPicture.asset(
                                      'images/addafter.svg',
                                      height: screenHeight * 0.16,
                                      width: screenHeight * 0.16,
                                      colorFilter: amPmFormat == 'PM'  ?null :  ColorFilter.mode(
                                        Colors.white.withOpacity(0.5), // Set the desired opacity here
                                        BlendMode.srcATop, // Set the blend mode
                                      ),
                                    ),
                                  ),
                                  //label: Text(''),
                                )
                              ],
                            )
                          ],
                        ),
                      ),

                      ///title of readings
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.06),                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Directionality(
                                textDirection: TextDirection.rtl,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(right: 8.0, top: 5),
                                  child: Text(
                                    'القراءات',
                                    style: GoogleFonts.tajawal(
                                      fontSize: 0.085 * screenWidth,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),

                      /// row of "morning readings"
                      SingleChildScrollView(
                        physics: const PageScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: callingListMorning(
                              data['MorningDiastolicReadings'],
                              data['MorningSystolicReadings'],
                              data['MorningHartRateReadings'],
                              data['MorningReadingsDateArabic']),
                        ),
                      ),

                      /// row of "Evening readings"
                      SingleChildScrollView(
                        physics: const PageScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: callingListEvening(
                              data['EveningDiastolicReadings'],
                              data['EveningSystolicReadings'],
                              data['EveningHartRateReadings'],
                              data['EveningReadingsDateArabic']),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const Loading();
      },
    );
  }

  /// morning :

  List<Widget> callingListMorning(
      List<dynamic> arrayMorningDiastolicRead1,
      List<dynamic> arrayMorningSystolicRead1,
      List<dynamic> arrayMorningHartRateRead1,
      List<dynamic> arrayMorningDate1) {
    cardListMorning.clear();
    fillCardsMorning(arrayMorningDiastolicRead1, arrayMorningSystolicRead1,arrayMorningHartRateRead1,arrayMorningDate1);
    return cardListMorning;
  }

  void fillCardsMorning(
      List<dynamic> arrayMorningDiastolicRead,
      List<dynamic> arrayMorningSystolicRead,
      List<dynamic> arrayMorningHartRateRead,
      List<dynamic> arrayMorningDate) {
    for (var i = arrayMorningDiastolicRead.length-1 ; i >=0 ; i--) {
      String read = " ${arrayMorningDiastolicRead[i].toInt()} / ${arrayMorningSystolicRead[i].toInt()}";
      String hartRate = "${arrayMorningHartRateRead[i].toInt()}";
      String date = arrayMorningDate[i].toString();
      cardListMorning.add(morningCard(read,hartRate,date));
    }
  }

  Widget morningCard(
      final String read,
      final String hartRate,
      final String dateC) {

    final splittedDate = dateC.split(' ');
    print("ana hone **");
    print(splittedDate.first);
    print(splittedDate[1]);
    print(splittedDate.last);


    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 10.0, left: 20),
        child: Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          // color: double.parse(read) >= 130.0 || double.parse(read) <= 80.0
          //     ? const Color(0xffC2402B)
          //     : const Color(0xff20AEC1),
          color: const Color(0xff20AEC1),
          elevation: 10.0,
          child: SizedBox(
            height: screenHeight * 0.14,
            width: screenWidth * 0.65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 15.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        'صباحاً',
                        style: GoogleFonts.tajawal(
                          fontSize: 0.06 * screenWidth,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        splittedDate.first,
                        style: GoogleFonts.tajawal(
                          fontSize: 0.04 * screenWidth,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${splittedDate[1]} am",
                        style: GoogleFonts.tajawal(
                          fontSize: 0.04 * screenWidth,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        read,
                        style: GoogleFonts.tajawal(
                            fontSize: 0.05 * screenWidth,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Row(
                        children: [
                          Text(
                            hartRate,
                            style: GoogleFonts.tajawal(
                                fontSize: 0.05 * screenWidth,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8.0, right: 5),
                            child:  Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(
                      // double.parse(read) >= 130.0 ? 'مرتفع'
                      //     : double.parse(read) <= 80.0 ? 'منخفض' : 'طبيعي'  ,
                      'طبيعي',
                      style: GoogleFonts.tajawal(
                        fontSize: 0.06 * screenWidth,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Evening :


  List<Widget> callingListEvening(
      List<dynamic> arrayEveningDiastolicRead1,
      List<dynamic> arrayEveningSystolicRead1,
      List<dynamic> arrayEveningHartRateRead1,
      List<dynamic> arrayEveningDate) {
    cardListEvening.clear();
    fillCardsEvening(arrayEveningDiastolicRead1,arrayEveningSystolicRead1,arrayEveningHartRateRead1, arrayEveningDate);
    return cardListEvening;
  }

  void fillCardsEvening(
      List<dynamic> arrayEveningDiastolicRead,
      List<dynamic> arrayEveningSystolicRead,
      List<dynamic> arrayEveningHartRateRead,
      List<dynamic> arrayEveningDate) {
    for (var i = arrayEveningDiastolicRead.length-1 ; i >=0 ; i--) {
      String read = "${arrayEveningSystolicRead[i].toInt()} / ${arrayEveningDiastolicRead[i].toInt()}";
      String hartRate = "${arrayEveningHartRateRead[i].toInt()}";
      String date = arrayEveningDate[i].toString();
      print("**** $read  $date");
      cardListEvening.add(eveningCard(read,hartRate, date));
    }
  }

  Widget eveningCard(
      final String read,
      final String hartRate,
      final String dateC) {
    final splittedDate = dateC.split(' ');
    print("ana hone **");
    print(splittedDate.first);
    print(splittedDate[1]);
    print(splittedDate.last);


    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 10.0, left: 20),
        child: Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          // color: double.parse(read) >= 180.0 || double.parse(read) <= 130.0
          //     ? const Color(0xffC2402B)
          //     : const Color(0xff167582),
          color: const Color(0xff167582),
          elevation: 10.0,
          child: SizedBox(
            height: screenHeight * 0.14,
            width: screenWidth * 0.65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 15.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(
                        child: Text(
                          'مساءاً',
                          style: GoogleFonts.tajawal(
                            fontSize: 0.06 * screenWidth,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${splittedDate.first}',
                        style: GoogleFonts.tajawal(
                          fontSize: 0.04 * screenWidth,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${splittedDate[1]} pm",
                        style: GoogleFonts.tajawal(
                          fontSize: 0.04 * screenWidth,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        read,
                        style: GoogleFonts.tajawal(
                            fontSize: 0.05 * screenWidth,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Row(
                        children: [
                          Text(
                            hartRate,
                            style: GoogleFonts.tajawal(
                                fontSize: 0.05 * screenWidth,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8.0, right: 5),
                            child:  Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(
                      // double.parse(read) >= 180.0 ? 'مرتفع'
                      //     : double.parse(read) <= 130.0 ? 'منخفض' : 'طبيعي'  ,
                      'طبيعي',
                      style: GoogleFonts.tajawal(
                        fontSize: 0.06 * screenWidth,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void time(DateTime dt) {
    period = formatDate(dt, [
      HH,
      ':',
      mm,
    ]);
    amPm = intl.DateFormat('a').format(dt).toString();

    if (amPm == 'AM') {
      wa2t = 'صباحا';
    } else {
      wa2t = 'مساءا';
    }

    if (dt.weekday == 1) {
      arabicDay = 'الاثنين'; //monday
    } else if (dt.weekday == 2) {
      arabicDay = 'الثلثاء'; //tues
    } else if (dt.weekday == 3) {
      arabicDay = 'الاربعاء'; //wed
    } else if (dt.weekday == 4) {
      arabicDay = 'الخميس'; //thurs
    } else if (dt.weekday == 5) {
      arabicDay = 'الجمعة'; //fri
    } else if (dt.weekday == 6) {
      arabicDay = 'السبت'; //sat
    } else if (dt.weekday == 7) {
      arabicDay = 'الاحد';
    }
    //sun
    cardDay = '$arabicDay - $period - $wa2t';
  }

  void timeInEnglish(dt) {
    if (dt.weekday == 1) {
      englishDay = 'mon'; //monday
    } else if (dt.weekday == 2) {
      englishDay = 'tues'; //tues
    } else if (dt.weekday == 3) {
      englishDay = 'wed'; //wed
    } else if (dt.weekday == 4) {
      englishDay = 'thurs'; //thurs
    } else if (dt.weekday == 5) {
      englishDay = 'fri'; //fri
    } else if (dt.weekday == 6) {
      englishDay = 'sat'; //sat
    } else if (dt.weekday == 7) {
      englishDay = 'sun';
    }
    //sun
    //return '$englishDay';
  }

  @override
  void initState() {

    super.initState();
    //WidgetsBinding.instance.addPostFrameCallback((_) => checkDate());
    morningCard;
    eveningCard;
    callingListMorning;
    fillCardsEvening;
    callingListEvening;
    fillCardsMorning;
    cardListMorning;
    cardListEvening;
  }

  @override
  void dispose() {
    _readingDiastolic.clear();
    _readingSystolic.clear();
    _readingHartRate.clear();


    _readingDiastolic.dispose();
    _readingSystolic.dispose();
    _readingHartRate.dispose();

    super.dispose();
  }
}

List<Widget> cardListMorning = [];
List<Widget> cardListEvening = [];
