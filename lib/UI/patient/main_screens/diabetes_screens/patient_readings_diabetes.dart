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
import '../../helper_page_dia.dart';



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
int globalCounterOfWeek = 0;
int currentReadingsCounter = 0;
int currentCommitmentCounter = 0;
FirebaseServiceDoctor doctor = FirebaseServiceDoctor();

class PatientInformationDiabetes extends StatefulWidget {
  const PatientInformationDiabetes({super.key});

  @override
  _PatientInformationDiabetesState createState() => _PatientInformationDiabetesState();
}

bool theDateChecked = false;
DateTime dt = DateTime.now();
intl.DateFormat formatter = intl.DateFormat('dd-MM-yyyy');
DateTime day = DateTime.now();
intl.DateFormat ww = intl.DateFormat('EEEE');

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
late DateTime lastOpenFromFireBase;
Future<DocumentSnapshot<Object?>>? getInitData() async {

  DocumentSnapshot<Map<String, dynamic>> dd  = await FirebaseFirestore.instance
      .collection('/patient')
      .doc(UserSimplePreferencesUser.getUserID())
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
      .doc(UserSimplePreferencesUser.getUserID())
      .collection('/diabetesWeeks')
      .doc(UserSimplePreferencesUser.getCtOfWeek() ?? "0")
      .get();

  await FirebaseFirestore.instance
      .collection('/patient')
      .doc(UserSimplePreferencesUser.getUserID()).set({
    'lastOpen': DateTime.now(),
  }, SetOptions(merge: true));

  return readingsData;
}


class _PatientInformationDiabetesState extends State<PatientInformationDiabetes> {
  final _reading = TextEditingController();
  late double screenHeight;
  late double screenWidth;
  late double textScale;
  bool loading = true;
  late double before;
  late double after;
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
                  child: SingleChildScrollView(
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
                                  padding: const EdgeInsets.only(top: 30.0, right: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'مرحبا',
                                        style: GoogleFonts.tajawal(
                                            fontSize: 22,
                                            color: const Color.fromRGBO(139, 139, 139, 1)),
                                      ),
                                      Text(
                                        namePA,
                                        style: GoogleFonts.tajawal(
                                            fontSize: 27,
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

                        ///Tow buttons "before" & "after"
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
                                  Text(
                                    'صائم',
                                    style: GoogleFonts.tajawal(
                                        fontSize: 0.04 * screenWidth,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff0B3C42)
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
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                        bool isCommitment = false;
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder:  (BuildContext context) => BackdropFilter(
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
                                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HelperScreenDia()));
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
                                                          padding: const EdgeInsets.only(top: 5.0),
                                                          child: Text(
                                                            'ادخال القراءة و انت صائم',
                                                            style: GoogleFonts.tajawal(
                                                                fontSize: 0.055 * screenWidth,
                                                                color: const Color(0xff0B3C42)
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 204,
                                                      child: TextField(
                                                        textAlign:
                                                        TextAlign.center,
                                                        keyboardType:
                                                        TextInputType
                                                            .number,
                                                        controller: _reading,
                                                        decoration:
                                                        InputDecoration(
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
                                                                dt = DateTime.now();
                                                                time(dt);
                                                                timeInEnglish(dt);
                                                                setState(() {
                                                                  tag = 1;
                                                                  before = double.parse(_reading.text);
                                                                  if (before <= 0) {
                                                                    showDialog(context: context,
                                                                        builder: (BuildContext context){
                                                                          return const CustomDialogBox();
                                                                        }
                                                                    );
                                                                  } else {
                                                                    // if (oldPA == true)
                                                                    //   doctor.writeReadingsBeforeOLD(
                                                                    //       data['BeforeReadings'], before,
                                                                    //       arabicDay,
                                                                    //       period,
                                                                    //       wa2t,data['Days_English_before'],englishDay
                                                                    //   );
                                                                    // else
                                                                    writeReadingsBefore(
                                                                      newRead: before,
                                                                      arabicDay: arabicDay,
                                                                      period: period,
                                                                      wa2t: wa2t,
                                                                      englishTime: englishDay,
                                                                      oldReadings: data['BeforeReadings'],
                                                                      oldDays: data['Days_English_before'],
                                                                      oldBeforeDateTime: data['BeforeDateTime'],
                                                                      oldBeforeReadingsDateArabic: data['BeforeReadingsDateArabic'],
                                                                      dateTime: DateTime.now(),
                                                                      commitmentCounter: isCommitment ? (currentCommitmentCounter + 1) : currentCommitmentCounter,
                                                                      readingsCounter: (currentReadingsCounter +1),
                                                                    );
                                                                    _reading.clear();
                                                                    Navigator.pop(context, before);

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
                                    },
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
                                  Text(
                                    'غير صائم',
                                    style: GoogleFonts.tajawal(
                                        fontSize: 0.04 * screenWidth,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff0B3C42)
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
                                    child: SvgPicture.asset(
                                      'images/addafter.svg',
                                      height: screenHeight * 0.16,
                                      width: screenHeight * 0.16,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        bool isCommitment = false;
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) => BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                            child: Container(
                                              height: screenHeight * 0.8,
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
                                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HelperScreenDia()));
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
                                                                'ادخال القراءة و انت غير صائم',
                                                                style: GoogleFonts.tajawal(
                                                                    fontSize: 0.055 * screenWidth,
                                                                    color: const Color(0xff0B3C42)
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                    Align(
                                                      alignment:
                                                      Alignment.center,
                                                      child: SizedBox(
                                                        width: 204,
                                                        child: TextField(
                                                          textAlign:
                                                          TextAlign.center,
                                                          keyboardType:
                                                          TextInputType
                                                              .number,
                                                          controller: _reading,
                                                          decoration:
                                                          InputDecoration(
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
                                                                  color:  Color
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
                                                    ),
                                                    CheckBoxCommitment(
                                                      onChanged: (bool newValue) {
                                                        setState(() {
                                                          isCommitment = newValue;
                                                        });
                                                      },
                                                      fillColor: const Color(0xff167582),
                                                    ),
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
                                                                dt = DateTime.now();
                                                                time(dt);
                                                                timeInEnglish(dt);
                                                                setState(() {
                                                                  tag = 0;
                                                                  after = double
                                                                      .parse(_reading
                                                                      .text);
                                                                  if (after <=
                                                                      0) {
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
                                                                    writeReadingsAfter(
                                                                      newRead: after,
                                                                      arabicDay: arabicDay,
                                                                      period: period,
                                                                      wa2t: wa2t,
                                                                      englishDay: englishDay,
                                                                      oldReadings: data['AfterReadings'],
                                                                      oldDays: data['Days_English_after'],
                                                                      oldAfterDateTime: data['AfterDateTime'],
                                                                      oldAfterReadingsDateArabic: data['AfterReadingsDateArabic'],
                                                                      dateTime: DateTime.now(),
                                                                      commitmentCounter: isCommitment ? currentCommitmentCounter + 1 : currentCommitmentCounter,
                                                                      readingsCounter: currentReadingsCounter+1,
                                                                    );
                                                                    _reading
                                                                        .clear();
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                });
                                                              },
                                                              // icon: Icon(Icons.add),
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
                                    },
                                    //label: Text(''),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),

                        ///title of readings
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.06),
                          child: Row(
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

                        /// row of "before readings"
                        SingleChildScrollView(
                          physics: const PageScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: callingListBefore(
                                data['BeforeReadings'],
                                data['BeforeReadingsDateArabic'],
                                data['BeforeDateTime']),
                          ),
                        ),

                        /// row of "after readings"
                        SingleChildScrollView(
                          physics: const PageScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: callingListAfter(data['AfterReadings'],
                                data['AfterReadingsDateArabic'], data['AfterDateTime']),
                          ),
                        )
                      ],
                    ),
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

  /// before :

  List<Widget> callingListBefore(List<dynamic> array11, List<dynamic> array22, List<dynamic> array33) {
    cardListBefore.clear();
    fillCardsBefore(array11, array22, array33);
    return cardListBefore;
  }

  void fillCardsBefore(
      List<dynamic> arrayBeforeRead, List<dynamic> arrayBeforeDate, List<dynamic> arrayBeforeDateTime) {
    for (var i = arrayBeforeRead.length-1 ; i >=0 ; i--) {
      String read = arrayBeforeRead[i].toString();
      String date = arrayBeforeDate[i].toString();
      DateTime fullDateTime = arrayBeforeDateTime[i].toDate();
      cardListBefore.add(beforeCard(read, date, fullDateTime));
    }
  }

  Widget beforeCard(final String read, final String dateC, DateTime fullDateTime) {

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
          color: double.parse(read) >= 130.0 || double.parse(read) <= 80.0
              ? const Color(0xffC2402B)
              : const Color(0xff20AEC1),
          elevation: 10.0,
          child: SizedBox(
            height: screenHeight * 0.14,
            width: screenWidth * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0,),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'صائم',
                        style: GoogleFonts.tajawal(
                          fontSize: 23,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        splittedDate.first,
                        style: GoogleFonts.tajawal(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3,),
                      Text(
                        intl.DateFormat('dd/M/yyyy').format(fullDateTime).toString(),
                        style: GoogleFonts.tajawal(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3,),
                      Text(
                        "${splittedDate[1]} ${splittedDate.last}",
                        style: GoogleFonts.tajawal(
                          fontSize: 15,
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
                            fontSize: 47,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Text(
                      double.parse(read) >= 130.0 ? 'مرتفع'
                          : double.parse(read) <= 80.0 ? 'منخفض' : 'طبيعي'  ,
                      style: GoogleFonts.tajawal(
                        fontSize: 30,
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

  /// after :

  List<Widget> callingListAfter(List<dynamic> array1, List<dynamic> array2, List<dynamic> array33) {
    cardListAfter.clear();
    fillCardsAfter(array1, array2, array33);
    return cardListAfter;
  }

  void fillCardsAfter(
      List<dynamic> arrayAfterRead, List<dynamic> arrayAfterDate, List<dynamic> arrayAfterDateTime) {
    for (var i = arrayAfterRead.length-1 ; i >=0 ; i--) {
      String read = arrayAfterRead[i].toString();
      String date = arrayAfterDate[i].toString();
      DateTime fullDateTime = arrayAfterDateTime[i].toDate();
      print("**** $read  $date");
      cardListAfter.add(afterCard(read, date,fullDateTime ));
    }
  }

  Widget afterCard(final String read, final String dateC, DateTime fullDateTime) {
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
          color: double.parse(read) >= 180.0 || double.parse(read) <= 130.0
              ? const Color(0xffC2402B)
              : const Color(0xff167582),
          elevation: 10.0,
          child: SizedBox(
            height: screenHeight * 0.14,
            width: screenWidth * 0.60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(
                        child: Text(
                          'غير صائم',
                          style: GoogleFonts.tajawal(
                            fontSize: 23,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        splittedDate.first,
                        style: GoogleFonts.tajawal(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3,),
                      Text(
                        intl.DateFormat('dd/M/yyyy').format(fullDateTime).toString(),
                        style: GoogleFonts.tajawal(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3,),
                      Text(
                        "${splittedDate[1]} ${splittedDate.last}",
                        style: GoogleFonts.tajawal(
                          fontSize: 15,
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
                            fontSize: 47,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Text(
                      double.parse(read) >= 180.0 ? 'مرتفع'
                          : double.parse(read) <= 130.0 ? 'منخفض' : 'طبيعي'  ,
                      style: GoogleFonts.tajawal(
                        fontSize: 30,
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
    beforeCard;
    afterCard;
    callingListBefore;
    fillCardsAfter;
    callingListAfter;
    fillCardsBefore;
    cardListBefore;
    cardListAfter;
  }

  @override
  void dispose() {
    _reading.clear();
    _reading.dispose();
    super.dispose();
  }
}

List<Widget> cardListBefore = [];
List<Widget> cardListAfter = [];


