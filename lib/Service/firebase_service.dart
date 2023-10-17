import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';


//TODO:  all of these class for Shared Preferences

 String uid = "ss";
 String type_Di = "none";

class FirebaseServiceDoctor {

  late String? firstnameDoctor;
  late String? lastnameDoctor;
  late String? doctorID;
  late String? dateBirthDoctor;
  late String? namePatient;
  late String? heightPatient;
  late String? weightPatient;
  late String? doctorId;
  late String? dateOfPatient;
  late String? nationalNumberPatient;
  late String? patentPhone;

  late int? highSystolicTarget;
  late int? lowSystolicTarget;

  late int? highDiastolicTarget;
  late int? lowDiastolicTarget;

  late bool? hasBloodPressure;
  late bool? hasDiabetes;

  late bool? isSmoker = false;
  late bool? isAlcoholic = false;

  FirebaseServiceDoctor({
    this.doctorID,
    this.lastnameDoctor,
    this.dateBirthDoctor,

    //patient info

    this.firstnameDoctor,
    this.dateOfPatient,
    this.heightPatient,
    this.namePatient,
    this.nationalNumberPatient,
    this.weightPatient,
    this.patentPhone,
    this.doctorId,
    //3ali
    this.highDiastolicTarget,
    this.lowDiastolicTarget,
    // Wati
    this.highSystolicTarget,
    this.lowSystolicTarget,

    this.hasBloodPressure,
    this.hasDiabetes,

    this.isSmoker,
    this.isAlcoholic
  });

  Future updateData() async {
    await FirebaseFirestore.instance
        .collection('/doctors')
        .doc(UserSimplePreferencesDoctorID.getDrID())
        .collection('/patient')
        .doc(UserSimplePreferencesUser.getUserID())
        .set({
      'Name': namePatient,
      'Doctor code': UserSimplePreferencesDoctorID.getDrID(),
      'Hieght': heightPatient,
      'weight': weightPatient,
      'Date of birth': dateOfPatient,
      'National ID': nationalNumberPatient,
      'Diabetes Type': type_Di,
      'User': UserSimplePreferencesUser.getUserID(),
    });
  }


  Future<DocumentReference<Object?>> patientUpdates() async {
    return await FirebaseFirestore.instance
        .collection('/doctors')
        .doc(UserSimplePreferencesDoctorID.getDrID() ?? doctorId)
        .collection('/patient')
        .doc(UserSimplePreferencesUser.getUserID() ?? uid);
  }





  void makePatientHasNewReadFalse({
    required String userID,
  }) async{

    (
        FirebaseFirestore.instance
            .collection('/doctors')
            .doc(UserSimplePreferencesDoctorID.getDrID())
            .collection('/patient')
            .doc(userID)
    ).set({
      //TODO:  must change it to blood or diabetes
      'isHaveNewRead' : false,
    }, SetOptions(merge: true));
  }

  void updateHistoryOfPatient({
    required String userID,
    required String newHistory,
  }) async{

    (
        FirebaseFirestore.instance
            .collection('/doctors')
            .doc(UserSimplePreferencesDoctorID.getDrID())
            .collection('/patient')
            .doc(userID)
    ).set({
      'history' : newHistory,
    }, SetOptions(merge: true));
  }
}


Future<void> createNewPatient({
  required String namePatient,
  required String doctorId,
  required String heightPatient,
  required String weightPatient,
  required String dateOfPatient,
  required String nationalNumberPatient,
  required String patentPhone,
  required bool hasDiabetes,
  required bool hasBloodPressure,

  required int highSystolicTarget,
  required int lowSystolicTarget,

  required int highDiastolicTarget,
  required int lowDiastolicTarget,
  required bool isSmoker,
  required bool isAlcoholic,
}) async {
  final User? user = FirebaseAuth.instance.currentUser;
  final uid = user?.uid;

  await FirebaseFirestore.instance
      .collection('/patient')
      .doc(uid == null || uid.isEmpty ? UserSimplePreferencesUser.getUserID() : uid)
      .set({
    'Name': namePatient,
    'Doctor code': doctorId,
    'DoctorID': UserSimplePreferencesDoctorID.getDrID(),
    'Hieght': heightPatient,
    'weight': weightPatient,
    'Date of birth': dateOfPatient,
    'National ID': nationalNumberPatient,
    'Diabetes Type': type_Di,
    'User': uid == null || uid.isEmpty ? UserSimplePreferencesUser.getUserID() : uid,
    'history': "",

    //TODO: new
    'isHaveNewDiabetesRead':false,
    'lastDiabetesRead': 0,
    'isBeforeBloodRead': false,

    //TODO: new
    'isHaveNewBloodRead' : false,
    'lastDiastolicBloodRead' : 0,
    'lastSystolicBloodRead' : 0,
    'lastHartRateRead': 0,
    'isMorningBloodRead': false,

    'phone':patentPhone,
    'hasDiabetes' : hasDiabetes,
    'hasBloodPressure' : hasBloodPressure,
    'highSystolicTarget' : highSystolicTarget,
    'lowSystolicTarget': lowSystolicTarget,
    'highDiastolicTarget' : highDiastolicTarget,
    'lowDiastolicTarget': lowDiastolicTarget,
    'isSmoker' : isSmoker,
    'isAlcoholic': isAlcoholic,

    'commitmentCounter': 0,
    'readingsCounter': 0,

    'counterOfWeeks':0,

    'lastOpen' : DateTime.now()
  });
  UserSimplePreferencesUser.setCtOfWeek("0");
  await createNewDiabetesWeek();
  await createNewBloodWeek();
}


Future<void> createNewDiabetesWeek() async {
  (await FirebaseFirestore.instance
      .collection('/patient')
      .doc(UserSimplePreferencesUser.getUserID() ?? uid)
      .collection('/diabetesWeeks')
      .doc(UserSimplePreferencesUser.getCtOfWeek()).set({
    'BeforeReadings': [],
    'BeforeReadingsDateArabic': [],
    'Days_English_before': [],
    'BeforeDateTime': [],
    'AfterReadings': [],
    'AfterReadingsDateArabic': [],
    'Days_English_after': [],
    'AfterDateTime': [],
  }));
}

void writeReadingsBefore(
    {
      required double newRead,
      required String arabicDay,
      required String period,
      required String wa2t,
      required String englishTime,
      required List<dynamic> oldReadings,
      required List<dynamic> oldDays,
      required List<dynamic> oldBeforeDateTime,
      required List<dynamic> oldBeforeReadingsDateArabic,

      required DateTime dateTime,

      required int readingsCounter,
      required int commitmentCounter,
    }) async {

  print("commitmentCounter / readingsCounter");
  print("$commitmentCounter / $readingsCounter");
  List<dynamic> before = oldReadings;
  List<dynamic> daysBefore = oldDays;
  List<dynamic> beforeReadingsDateArabicList = oldBeforeReadingsDateArabic;
  List<dynamic> beforeDateTimeList = oldBeforeDateTime;

  before.add(newRead);
  daysBefore.add(englishTime);
  beforeReadingsDateArabicList.add("$arabicDay $period $wa2t");
  beforeDateTimeList.add(dateTime);


  await FirebaseFirestore.instance
          .collection('/patient')
          .doc(UserSimplePreferencesUser.getUserID() ?? uid)
          .collection('/diabetesWeeks')
          .doc(UserSimplePreferencesUser.getCtOfWeek()).set({
    'BeforeReadings': before,
    'Days_English_before': daysBefore,
    'BeforeReadingsDateArabic': beforeReadingsDateArabicList,
    'BeforeDateTime': beforeDateTimeList,
  }, SetOptions(merge: true));


  await FirebaseFirestore.instance
      .collection('/patient')
      .doc(UserSimplePreferencesUser.getUserID() ?? uid).set({
    'isHaveNewDiabetesRead':true,
    'lastDiabetesRead': newRead,
    'isBeforeBloodRead': true,
    'readingsCounter' : readingsCounter,
    'commitmentCounter': commitmentCounter,
  }, SetOptions(merge: true));

}

void writeReadingsAfter(
    {
      required double newRead,
      required String arabicDay,
      required String period,
      required String wa2t,
      required String englishDay,
      required List<dynamic> oldReadings,
      required List<dynamic> oldDays,
      required DateTime dateTime,
      required List<dynamic> oldAfterDateTime,
      required List<dynamic> oldAfterReadingsDateArabic,
      required int readingsCounter,
      required int commitmentCounter,
    }) async {
  print("commitmentCounter / readingsCounter");
  print("$commitmentCounter / $readingsCounter");
  List<dynamic> after = oldReadings;
  List<dynamic> daysAfter = oldDays;
  List<dynamic> afterDateTimeList = oldAfterDateTime;
  List<dynamic> afterReadingsDateArabicList = oldAfterReadingsDateArabic;

  after.add(newRead);
  daysAfter.add(englishDay);
  afterDateTimeList.add(dateTime);
  afterReadingsDateArabicList.add("$arabicDay $period $wa2t");

  await FirebaseFirestore.instance
      .collection('/patient')
      .doc(UserSimplePreferencesUser.getUserID() ?? uid)
      .collection('/diabetesWeeks')
      .doc(UserSimplePreferencesUser.getCtOfWeek()).set({
    'AfterReadings': after,
    'Days_English_after': daysAfter,
    'AfterReadingsDateArabic': afterReadingsDateArabicList,
    'AfterDateTime': afterDateTimeList,
  }, SetOptions(merge: true));


  await FirebaseFirestore.instance
      .collection('/patient')
      .doc(UserSimplePreferencesUser.getUserID() ?? uid).set({
    'isHaveNewDiabetesRead':true,
    'lastDiabetesRead': newRead,
    'isBeforeBloodRead': false,
    'readingsCounter' : readingsCounter,
    'commitmentCounter': commitmentCounter,
  }, SetOptions(merge: true));

}


Future<void> createNewBloodWeek() async {
  (await FirebaseFirestore.instance
      .collection('/patient')
      .doc(UserSimplePreferencesUser.getUserID() ?? uid)
      .collection('/bloodWeeks')
      .doc(UserSimplePreferencesUser.getCtOfWeek()).set({
    // 'MorningReadings': [],
    'MorningDiastolicReadings': [],
    'MorningSystolicReadings': [],
    'MorningHartRateReadings': [],

    'MorningReadingsDateArabic': [],
    'Days_English_morning': [],
    'MorningDateTime': [],


    //'EveningReadings': [],
    'EveningDiastolicReadings': [],
    'EveningSystolicReadings': [],
    'EveningHartRateReadings': [],

    'EveningReadingsDateArabic': [],
    'Days_English_evening': [],
    'EveningDateTime': [],
  }));
}

//TODO:
void writeReadingsMorning(
    {
      required double newDiastolicRead,
      required double newSystolicRead,
      required double newHartRateRead,

      required String arabicDay,
      required String period,
      required String wa2t,
      required String englishTime,

      required List<dynamic> oldDiastolicReadings,
      required List<dynamic> oldSystolicReadings,
      required List<dynamic> oldHartRateReadings,
      required List<dynamic> oldDays,
      required List<dynamic> oldMorningDateTime,
      required List<dynamic> oldMorningReadingsDateArabic,
      required DateTime dateTime,

      required int readingsCounter,
      required int commitmentCounter,
    }) async {
  print("commitmentCounter / readingsCounter");
  print("$commitmentCounter / $readingsCounter");
  List<dynamic> morningDiastolic = oldDiastolicReadings;
  List<dynamic> morningSystolic = oldSystolicReadings;
  List<dynamic> morningHartRate = oldHartRateReadings;

  List<dynamic> daysMorning = oldDays;
  List<dynamic> morningReadingsDateArabicList = oldMorningReadingsDateArabic;
  List<dynamic> morningDateTimeList = oldMorningDateTime;

  morningDiastolic.add(newDiastolicRead);
  morningSystolic.add(newSystolicRead);
  morningHartRate.add(newHartRateRead);

  daysMorning.add(englishTime);
  morningReadingsDateArabicList.add("$arabicDay $period $wa2t");
  morningDateTimeList.add(dateTime);


  await FirebaseFirestore.instance
          .collection('/patient')
          .doc(UserSimplePreferencesUser.getUserID() ?? uid)
          .collection('/bloodWeeks')
          .doc(UserSimplePreferencesUser.getCtOfWeek()).set({
    // 'MorningReadings': morning,
    'MorningDiastolicReadings': morningDiastolic,
    'MorningSystolicReadings': morningSystolic,
    'MorningHartRateReadings': morningHartRate,
    'Days_English_morning': daysMorning,
    'MorningReadingsDateArabic': morningReadingsDateArabicList,
    'MorningDateTime': morningDateTimeList,
  }, SetOptions(merge: true));


  await FirebaseFirestore.instance
      .collection('/patient')
      .doc(UserSimplePreferencesUser.getUserID() ?? uid).set({
    'isHaveNewBloodRead' : true,
    'lastDiastolicBloodRead' : newDiastolicRead,
    'lastSystolicBloodRead' : newSystolicRead,
    'lastHartRateRead': newHartRateRead,
    'isMorningBloodRead': true,
    'readingsCounter' : readingsCounter,
    'commitmentCounter': commitmentCounter,
  }, SetOptions(merge: true));

}



void writeReadingsEvening(
    {
      required double newDiastolicRead,
      required double newSystolicRead,
      required double newHartRateRead,

      required String arabicDay,
      required String period,
      required String wa2t,
      required String englishDay,

      required List<dynamic> oldDiastolicReadings,
      required List<dynamic> oldSystolicReadings,
      required List<dynamic> oldHartRateReadings,
      required List<dynamic> oldDays,

      required DateTime dateTime,
      required List<dynamic> oldEveningDateTime,
      required List<dynamic> oldEveningReadingsDateArabic,

      required int readingsCounter,
      required int commitmentCounter,
    }) async {
  print("commitmentCounter / readingsCounter");
  print("$commitmentCounter / $readingsCounter");
  List<dynamic> eveningDiastolic = oldDiastolicReadings;
  List<dynamic> eveningSystolic = oldSystolicReadings;
  List<dynamic> eveningHartRate = oldHartRateReadings;


  List<dynamic> daysEvening = oldDays;
  List<dynamic> eveningDateTimeList = oldEveningDateTime;
  List<dynamic> eveningReadingsDateArabicList = oldEveningReadingsDateArabic;

  eveningDiastolic.add(newDiastolicRead);
  eveningSystolic.add(newSystolicRead);
  eveningHartRate.add(newHartRateRead);


  daysEvening.add(englishDay);
  eveningDateTimeList.add(dateTime);
  eveningReadingsDateArabicList.add("$arabicDay $period $wa2t");

  await FirebaseFirestore.instance
      .collection('/patient')
      .doc(UserSimplePreferencesUser.getUserID() ?? uid)
      .collection('/bloodWeeks')
      .doc(UserSimplePreferencesUser.getCtOfWeek()).set({

    // 'EveningReadings': evening,

    'EveningDiastolicReadings': eveningDiastolic,
    'EveningSystolicReadings': eveningSystolic,
    'EveningHartRateReadings': eveningHartRate,

    'Days_English_evening': daysEvening,
    'EveningReadingsDateArabic': eveningReadingsDateArabicList,
    'EveningDateTime': eveningDateTimeList,
  }, SetOptions(merge: true));


  await FirebaseFirestore.instance
      .collection('/patient')
      .doc(UserSimplePreferencesUser.getUserID() ?? uid).set({
    'isHaveNewBloodRead' : true,
    'lastDiastolicBloodRead' : newDiastolicRead,
    'lastSystolicBloodRead' : newSystolicRead,
    'lastHartRateRead': newHartRateRead,
    'isMorningBloodRead': false,
    'readingsCounter' : readingsCounter,
    'commitmentCounter': commitmentCounter,
  }, SetOptions(merge: true));

}



//TODO:  all of these class for Shared Preferences

class UserSimplePreferencesUser {
  static late SharedPreferences _preferences;
  static const _keyUsername = 'username1';
  static const _keyPaName = 'PaName';
  static const _keyLastOpen = 'lastOpen';
  static const _keyCtOfWeek = 'CtOfWeek';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUserID(String uid) async =>
      await _preferences.setString(_keyUsername, uid);

  static Future setPaDiabetes(bool haveDiabetes ) async => await _preferences.setBool("haveDiabetes", haveDiabetes);
  static Future setPaBlood(bool haveBlood) async => await _preferences.setBool("haveBlood", haveBlood);

  static Future setPaName(String name) async =>
      await _preferences.setString(_keyPaName, name);
  static Future setLastOpen(String lastOpen) async =>
      await _preferences.setString(_keyLastOpen, lastOpen);
  static Future setCtOfWeek(String ct) async => await _preferences.setString(_keyCtOfWeek, ct);

  static String? getUserID() => _preferences.getString(_keyUsername);

  static bool? getPaDiabetes() => _preferences.getBool("haveDiabetes");
  static bool? getPaBlood() => _preferences.getBool("haveBlood");

  static String? getPaName() => _preferences.getString(_keyPaName);
  static String? getLastOpen() => _preferences.getString(_keyLastOpen);
  static String? getCtOfWeek() => _preferences.getString(_keyCtOfWeek);
}

class UserSimplePreferencesUserName {
  static late SharedPreferences _preferences;
  static const _keyUsername = 'username1';
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();
  static Future setPaName(String username) async =>
      await _preferences.setString(_keyUsername, username);
  static String? getPaName() => _preferences.getString(_keyUsername);
}

class UserSimplePreferencesDoctorID {
  static late SharedPreferences _preferences;
  static const _keyUsername = 'id';
  static const _keyUserType = 'type';
  static const _keyDrName = 'PaName';
  static Future init() async => _preferences = await SharedPreferences.getInstance();
  static Future setDrID(String id) async =>await _preferences.setString(_keyUsername, id);
  static Future setDrName(String name) async => await _preferences.setString(_keyDrName, name);
  static Future setUserType(String type) async => await _preferences.setString(_keyUserType, type);

  static String? getDrID() => _preferences.getString(_keyUsername);
  static String? getDrName() => _preferences.getString(_keyDrName);
  static String? geUserType() => _preferences.getString(_keyUserType);


}

class UserSimplePreferencesTypeOfUser {
  static late SharedPreferences _preferences;

  static Future init() async => _preferences = await SharedPreferences.getInstance();

}